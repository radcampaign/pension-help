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
  has_many :locations, :order => 'is_hq desc, position asc', :dependent => :destroy
  has_many :plans, :dependent => :destroy
  has_many :publications, :dependent => :destroy
  has_one :publication, :class_name => "Publication"
  has_one :hq, :class_name => "Location", :conditions => "is_hq=1 and is_provider=1"
  has_many :dropin_addresses, :through => :locations, :source => :addresses, :conditions => "address_type = 'dropin'", :order => "is_hq desc"
  has_many :mailing_addresses, :through => :locations, :source => :addresses, :conditions => "address_type = 'mailing'", :order => "is_hq desc"
  has_one :restriction, :dependent => :destroy

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
        and a.is_active = 1
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
        and a.is_active = 1
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

    active = (params[:active].nil?) ? false : true

    agencies = Hash.new
    locations.each do |location|
      if active
        agencies[location.agency.id] = location.agency if location.agency.is_active
      else
        agencies[location.agency.id] = location.agency
      end
    end
    plans.each do |plan|
      if active
        agencies[plan.agency.id] = plan.agency if plan.agency.is_active
      else
        agencies[plan.agency.id] = plan.agency
      end
    end

    #Adding nation-wide agencies, if not yet selected
    get_nation_wide_agencies().each {|agency| agencies[agency.id] = agency unless agencies.has_key?(agency.id)}

    agencies = agencies.values
    Agency.mark_locations_visible(agencies, locations)
    return agencies
  end

  def has_visible_locations?
    locations.detect() {|loc| loc.visible_in_view }
  end
  #Sorts agencies by given column and direction.
  def self.sort_agencies(agencies, sort_col, dir)
    case sort_col
      when 'default'
        agencies.sort! { |a,b| a.compare_by_default(b, dir) }
      when 'name'
        agencies.sort! { |a,b| a.compare_by_name(b, dir) }
      when 'state'
        agencies.sort! { |a,b| a.compare_by_state(b, dir) }
      when 'category'
        agencies.sort! { |a,b| a.compare_by_category(b, dir) }
      when 'counseling'
        agencies.sort! { |a,b| a.compare_by_counseling(b, dir) }
      when 'result'
        agencies.sort! { |a,b| a.compare_by_result(b, dir) }
      when 'active'
        agencies.sort! { |a,b| a.compare_by_active(b, dir) }
      when 'provider'
        agencies.sort! { |a,b| a.compare_by_provider(b, dir) }
    end
    agencies
  end

  #Comparison functions
  #sorting by multiple columns: ticket #211
  def compare_by_default(b, dir)
    compare_by_active(b, dir)
  end

  def compare_by_name(b, dir)
    compare_name(b, dir)
  end

  def compare_by_state(b, dir)
    compare_state(b, dir) do
      self.compare_category(b, 1) do
        self.compare_result(b, 1) do
          self.compare_name(b, 1)
        end
      end
    end
  end

  def compare_by_category(b, dir)
    compare_category(b, dir) do
      self.compare_result(b, 1) do
        self.compare_name(b, 1)
      end
    end
  end

  def compare_by_result(b, dir)
    compare_result(b, dir) do
      self.compare_category(b, 1) do
        self.compare_name(b, 1)
      end
    end
  end

  def compare_by_counseling(b, dir)
    compare_counseling(b, dir) do
      self.compare_provider(b, 1) do
        self.compare_category(b, 1) do
          self.compare_result(b, 1) do
            self.compare_name(b, 1)
          end
        end
      end
    end
  end

  def compare_by_provider(b, dir)
    compare_provider(b, dir) do
      self.compare_counseling(b, 1) do
        self.compare_category(b, 1) do
          self.compare_result(b, 1) do
            self.compare_name(b, 1)
          end
        end
      end
    end
  end

  def compare_by_active(b, dir)
    compare_active(b, dir) do
      self.compare_provider(b, 1) do
        self.compare_counseling(b, 1) do
          self.compare_category(b, 1) do
            self.compare_result(b, 1) do
              self.compare_name(b, 1)
            end
          end
        end
      end
      
    end
  end

  #Compares two agencies by their name
  def compare_name(b, dir = 1)
    if (name < b.name)
      -1 * dir
    elsif (name > b.name)
      1 * dir
    else
      if block_given?
        yield
      else
        0
      end
    end
  end

  #Compares two agencies by state
  def compare_state(b, dir = 1)
    if (locations.empty? || locations.first.dropin_address.blank?) && (!b.locations.empty? && !b.locations.first.dropin_address.blank?)
      1 * dir
    elsif (!locations.empty? && !locations.first.dropin_address.blank?) && (b.locations.empty? || b.locations.first.dropin_address.blank?)
      -1 * dir
    elsif (locations.empty? && locations.first.dropin_address.blank?) && (b.locations.empty? && b.locations.first.dropin_address.blank?)
      if block_given?
        yield
      else
        0
      end
    else
      if (locations.first.dropin_address.state_abbrev.blank? || b.locations.first.dropin_address.state_abbrev.blank?)
        if (locations.first.dropin_address.state_abbrev.blank? && !b.locations.first.dropin_address.state_abbrev.blank?)
          1 * dir
        elsif (!locations.first.dropin_address.state_abbrev.blank? && b.locations.first.dropin_address.state_abbrev.blank?)
          -1 * dir
        else
          if block_given?
            yield
          else
            0
          end
        end
      else
        if (locations.first.dropin_address.state_abbrev < b.locations.first.dropin_address.state_abbrev)
          -1 * dir
        elsif (locations.first.dropin_address.state_abbrev > b.locations.first.dropin_address.state_abbrev)
          1 * dir
        else
          if block_given?
            yield
          else
            0
          end
        end
      end
    end
  end

  #Compares two agencies by their categories.
  def compare_category(b, dir = 1)
    if (agency_category.name > b.agency_category.name)
      1 * dir
    elsif (agency_category.name < b.agency_category.name)
      -1 * dir
    else
      if block_given?
        yield
      else
        0
      end
    end
  end

  #Compares two agencies by counseling.
  def compare_counseling(b, dir = 1)
    if (use_for_counseling && !b.use_for_counseling)
      -1 * dir
    elsif (!use_for_counseling && b.use_for_counseling)
      1 * dir
    else
      if block_given?
        yield
      else
        0
      end
    end
  end

  #Compares two agencies by their result.
  def compare_result(b, dir = 1)
    if (result_type.nil? && !b.result_type.nil?)
      1 * dir
    elsif (!result_type.nil? && b.result_type.nil?)
      -1 * dir
    elsif (result_type.nil? && b.result_type.nil?)
      if block_given?
        yield
      else
        0
      end
    else
      if (result_type.name.blank? || b.result_type.name.blank?)
        if (result_type.name.blank? && !b.result_type.name.blank?)
          1 * dir
        elsif (!result_type.name.blank? && b.result_type.name.blank?)
          -1 * dir
        else
          if block_given?
            yield
          else
            0
          end
        end
      else
        if (result_type.name < b.result_type.name)
          -1 * dir
        elsif (result_type.name > b.result_type.name)
          1 * dir
        else
          if block_given?
            yield
          else
            0
          end
        end
      end
    end
  end

  #Compares two agencies by active column.
  def compare_active(b, dir = 1)
    if (is_active && !b.is_active)
      -1 * dir
    elsif (!is_active && b.is_active)
      1 * dir
    else
      if block_given?
        yield
      else
        0
      end
    end
  end

  #Compares two agencies by provider column.
  def compare_provider(b, dir = 1)
    if (is_provider && !b.is_provider)
      -1 * dir
    elsif (!is_provider && b.is_provider)
      1 * dir
    else
      if block_given?
        yield
      else
        0
      end
    end
  end

  private
  def self.find_locations params
    query = <<-SQL
      select
          l.*
      from
          locations as l
    SQL

    query += " join restrictions as r on l.id = r.location_id " if !params['state_abbrevs'].nil? && params['state_abbrevs'].size > 0 && !params['state_abbrevs'][0].blank?
    query = prepare_sql_query query, params
    Location.find_by_sql query
  end
  
  def self.find_plans params
    query = <<-SQL
      select
          p.*
      from
          plans as p
    SQL

    query += "  join restrictions as r on p.id = r.plan_id " if !params['state_abbrevs'].nil? && params['state_abbrevs'].size > 0 && !params['state_abbrevs'][0].blank?
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
  
  #sets visibility flag for a given location
  def self.mark_locations_visible(agencies, locations)
    agencies.each do |agency|
      locs = locations.find_all { |loc| loc.agency_id == agency.id }
      agency.locations.each do |location|
        location.visible_in_view = true if locs.find { |elem| elem.id == location.id}
      end
    end
    
  end

  def self.prepare_sql_query(query, params)
    restrictions = ['state_abbrevs', 'county_ids', 'city_ids', 'zip_ids']

    cond_params = Array.new
    joins = ''
    cond = Array.new

    #for each restriction
    restrictions.each do |r|
      if (!params[r].nil? && params[r].size > 0 && !params[r][0].blank?)
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

  #Finds agencies that serves all country, that means all agencies with locations
  # that do not have any geographic restrictions
  # - but make sure the locations 'serve' people (use_for_counseling=1 and is_provider=1 and is_active=1)
  def self.get_nation_wide_agencies()
    query =<<SQL_QUERY
    select
      agencies.*
    from
      agencies left join locations as l on agencies.id = l.agency_id
      left join restrictions as r on r.location_id = l.id
      left join restrictions_states rs on rs.restriction_id = r.id
      left join restrictions_counties as rc on rc.restriction_id = r.id
      left join restrictions_cities as rct on rct.restriction_id = r.id
      left join restrictions_zips as rz on rz.restriction_id = r.id
    where
      rs.restriction_id IS NULL AND
      rc.restriction_id IS NULL AND
      rct.restriction_id IS NULL AND
      rz.restriction_id IS NULL AND
      agencies.use_for_counseling = 1 AND
      agencies.is_active = 1 AND
      l.is_provider = 1
SQL_QUERY

    Agency.find_by_sql(query)
  end
end
