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
    home_county = (z=Zip.find_by_zipcode(home_geo_zip)) ? z.county_id : nil
    
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
                            left join restrictions_counties rc on rc.restriction_id = r.id
                            left join restrictions_zips rz on rz.restriction_id = r.id",
                 :conditions => "addresses.latitude is not null and locations.is_provider=1
                            and (rs.restriction_id is null or rs.state_abbrev = '#{home_state}')
                            and (rc.restriction_id is null or rc.county_id='#{home_county}')
                            and (rz.restriction_id is null or rz.zipcode='#{counseling.zipcode}' )")
                 
# FIXME:  Two problems exist here:
# 1 - we can't join on restriction_cities, because we don't have a city_id, and it's non-trivial to look one up based on zipcode (consider a zip with more than one city - e.g. 04106 = Portland + South Portland)                 
                                 
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
    unless @is_provider
      @is_provider = locations.count(:id, :conditions => 'is_provider = 1') > 0
    end
    @is_provider
  end

  def self.find_agencies filter
    locations = find_locations filter
    #Do not search by plans
#    plans = find_plans filter

    agencies = Hash.new
    agencies_ids = Array.new
    #if we filter by agency's provider type, and given agency is not 'proper',
    # we put its id in this table so we don't have to check it again.
    ignored_agencies_ids = Array.new
#    [locations, plans].each do |arr|
    [locations].each do |arr|
      arr.each do |elem|
        agency_id = elem.agency_id
        #checks if we already have this agency or should be ignored
        if (!agencies_ids.include?(agency_id) && !ignored_agencies_ids.include?(agency_id))
          agency_tmp = Agency.find(agency_id, :include => [{:locations =>[:agency,:dropin_address,:restrictions]}])
          #filter DSP/NSP
          unless filter.get_provider_type.blank?
            if agency_tmp.get_provider_type != filter.get_provider_type
              #ignore this agency, 
              ignored_agencies_ids << agency_tmp.id
              next
            end
          end
          agencies[agency_id] = agency_tmp
          agencies_ids << agency_id
        end
      end
    end

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
      when 'nspdsp'
        agencies.sort! { |a,b| a.compare_by_provider_type(b, dir) }
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
  
  def compare_by_provider_type(b, dir)
    compare_provider_type(b, dir) do 
      self.compare_name(b, 1)
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
    #consider refactoring as: if (self.best_state.nil?) && (!b.best_state.nil?) and so on
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
  
  def compare_provider_type(b, dir = 1)
    a = get_provider_type
    b = b.get_provider_type
    if (a.blank? || b.blank?)
      if (a.blank? && !b.blank?)
        1 * dir
      elsif (!a.blank? && b.blank?)
        -1 * dir
      else
        if block_given?
          yield
        else
          0
        end
      end
    else
      if (a  < b)
        -1 * dir
      elsif (a > b)
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

  #Returns provider type based on locations
  def get_provider_type
    #Hash with counts for each type of provider type
    providers = Hash.new
    locations.each do |loc|
      loc_provider = loc.get_provider_type
      if providers[loc_provider].nil?
        providers[loc_provider] = 0
      end
      providers[loc_provider] += providers[loc_provider]
    end
    nsp = providers['NSP']
    dsp = providers['DSP']
    return 'NSP' if nsp and not dsp
    return 'DSP' if dsp and not nsp 
    return 'NSP/DSP' if dsp and nsp
    return ''
  end
  
  private
  def self.find_locations filter
    result = Array.new
    query = filter.get_find_locations_query
    result += Location.find_by_sql query
    query = filter.get_find_locations_for_state_local_agencies
    result += Location.find_by_sql query
    return result
  end
  
  def self.find_plans filter
    query = filter.get_find_plans_query
    Plan.find_by_sql query
  end
  
  #sets visibility flag for a given location
  def self.mark_locations_visible(agencies, locations)
    agencies.each do |agency|
      locs = locations.find_all { |loc| loc.agency_id == agency.id }
      agency.locations.each do |location|
        location.visible_in_view = true if locs.find { |elem| elem.id == location.id}
      end
    end
    
  end

  #helper method to get most relevant state for an agency
  def best_state
    dropin_addresses.first.state_abbrev unless dropin_addresses.blank?
  end

end
