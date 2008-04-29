# == Schema Information
# Schema version: 41
#
# Table name: agencies
#
#  id                 :integer(11)   not null, primary key
#  agency_category_id :integer(11)   
#  result_type_id     :integer(11)   
#  name               :string(255)   
#  name2              :string(255)   
#  description        :text          
#  data_source        :string(255)   
#  is_active          :boolean(1)    
#  url                :string(255)   
#  url_title          :string(255)   
#  url2               :string(255)   
#  url2_title         :string(255)   
#  comments           :text          
#  services_provided  :text          
#  use_for_counseling :boolean(1)    
#  created_at         :datetime      
#  updated_at         :datetime      
#  updated_by         :string(255)   
#  legacy_code        :string(10)    
#  legacy_status      :string(255)   
#  legacy_category1   :string(255)   
#  legacy_category2   :string(255)   
#  fmp2_code          :string(10)    
#

class Agency < ActiveRecord::Base
  has_many :locations, :order => 'is_hq desc, position asc'
  has_many :plans
  has_many :publications
  has_one :publication, :class_name => "Publication"
  has_one :hq, :class_name => "Location", :conditions => "is_hq=1 and is_provider=1"
  has_many :dropin_addresses, :through => :locations, :source => :addresses, :conditions => "address_type = 'dropin'", :order => "is_hq desc"
  has_many :mailing_addresses, :through => :locations, :source => :addresses, :conditions => "address_type = 'mailing'", :order => "is_hq desc"
  has_one :restriction

  has_enumerated :agency_category
  has_enumerated :result_type

  composed_of :pha_contact, :class_name => PhaContact,
    :mapping => [
      [:pha_contact_name, :name],
      [:pha_contact_title, :title],
      [:pha_contact_phone, :phone],
      [:pha_contact_email, :email],
    ]
  
  validates_presence_of(:agency_category)
  validates_presence_of(:name)
  
  def best_location(counseling)
    return hq unless counseling.zipcode || hq.nil?
    
    home_geo_zip = ZipImport.find(counseling.zipcode)
    home_state = home_geo_zip.nil? ? '' : home_geo_zip.state_abbrev

    # out of state should find hq, unless there's a state restriction
    if hq && home_state == dropin_addresses.first.state_abbrev
      order = 'rs.state_abbrev desc, distance'
    else
      order = 'rs.state_abbrev desc, is_hq desc, distance'
    end

    address = dropin_addresses.find(:first, :origin => home_geo_zip, 
                 :order => order,
                 :joins => "left join restrictions r on r.location_id = locations.id
                            left join restrictions_states rs on rs.restriction_id = r.id
                                and rs.state_abbrev = '#{home_state}'",
                 :conditions => "addresses.latitude is not null and is_provider=1")
                                 
    # return the relevant location instead of the address                                  
    return address.location if address 
    
  end
  
  def self.age_restrictions?(work_state_abbrev, hq_state_abbrev, pension_state_abbrev, home_state)
    sql = <<-SQL
        select a.id from agencies a
        join locations l on l.agency_id = a.id and l.is_provider = 1
        join restrictions r on r.location_id = l.id
        join restrictions_states rs on rs.restriction_id = r.id 
              and rs.state_abbrev IN (?,?,?,?)
        where a.agency_category_id = ?
        and a.use_for_counseling = 1
        and (r.minimum_age is not null) 
        SQL

    Agency.find_by_sql([sql, work_state_abbrev, hq_state_abbrev, pension_state_abbrev, 
                                 home_state, AgencyCategory['Service Provider']]).size > 0
    
  end
  
  def self.income_restrictions?(work_state_abbrev, hq_state_abbrev, pension_state_abbrev, home_state)
    sql = <<-SQL
        select a.id from agencies a
        join locations l on l.agency_id = a.id and l.is_provider = 1
        join restrictions r on r.location_id = l.id
        join restrictions_states rs on rs.restriction_id = r.id 
              and rs.state_abbrev IN (?,?,?,?)
        where a.agency_category_id = ?
        and a.use_for_counseling = 1
        and (r.max_poverty is not null) 
        SQL

    Agency.find_by_sql([sql, work_state_abbrev, hq_state_abbrev, pension_state_abbrev, 
                                 home_state, AgencyCategory['Service Provider']]).size > 0
  end
  
  def is_provider
    locations.count(:id, :conditions => 'is_provider = 1') > 0
  end
  
  def self.find_agencies params
    locations = find_locations params
    plans = find_plans params

    agencies = Hash.new
    locations.each {|location| agencies[location.agency.id] = location.agency}
    plans.each {|plan| agencies[plan.agency.id] = plan.agency}

    agencies
    return locations, plans, agencies
  end
  
  private
  def self.find_locations params
    query = <<-SQL
      select
          l.*
      from
          locations as l join restrictions as r on l.id = r.location_id
    SQL

    query = prepare_sql_query query, params
    Location.find_by_sql query
  end
  
  def self.find_plans params
    query = <<-SQL
      select
          p.*
      from
          plans as p join restrictions as r on p.id = r.plan_id
    SQL

    query = prepare_sql_query(query, params)
    Plan.find_by_sql query
  end

  @@JOIN_TABLES = {
    'state_abbrevs' => {
      'join' => ' JOIN restrictions_states AS rs ON r.id = rs.restriction_id',
      'col' => 'rs.state_abbrev'
    },
    'county_ids' => {
      'join' => ' JOIN restrictions_counties AS rcu ON r.id = rcu.restriction_id',
      'col' => 'rcu.county_id'
    },
    'city_ids' => {
      'join' => ' JOIN restrictions_cities AS rct ON r.id = rct.restriction_id',
      'col' => 'rct.city_id'
    },
    'zip_ids' => {
      'join' => ' JOIN restrictions_zips AS rz ON r.id = rz.restriction_id',
      'col' => 'rz.zipcode'
      }
  }

  def self.prepare_sql_query(query, params)
    restrictions = ['state_abbrevs', 'county_ids', 'city_ids', 'zip_ids']

    cond_params = Array.new
    joins = ''
    cond = Array.new

    #for each restriction
    restrictions.each do |r|
      if (!params[r].nil? && params[r].size > 0 && !params[r][0].empty?)
        joins << @@JOIN_TABLES[r]['join']
        cond_tmp = "("
        params[r].each do |elem|
          cond_tmp << "#{@@JOIN_TABLES[r]['col']} = ?"
          cond_params << elem
          cond_tmp << " OR " unless elem == params[r].last
        end
        cond_tmp << ")"
        cond << cond_tmp
      end
    end
    cond = cond.join(' AND ')
    cond = ' WHERE ' + cond if cond.size > 1

    #insert into query proper joins and conditions
    query << joins << ' '
    query << cond << ' '

    result = []
    result << query
    result.concat(cond_params)

    result
  end
end
