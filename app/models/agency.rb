# == Schema Information
# Schema version: 35
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
  has_many :locations
  has_many :plans
  has_many :publications
  has_one :publication, :class_name => "Publication"
  has_one :hq, :class_name => "Location", :conditions => "is_hq=1 and is_provider=1"
  has_many :dropin_addresses, :through => :locations, :source => :addresses, :conditions => "address_type = 'dropin'", :order => "is_hq desc"
  has_many :mailing_addresses, :through => :locations, :source => :addresses, :conditions => "address_type = 'mailing'", :order => "is_hq desc"
  has_one :restriction

  has_enumerated :agency_category
  has_enumerated :result_type
  
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
  
end
