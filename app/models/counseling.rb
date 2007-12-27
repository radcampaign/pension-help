# == Schema Information
# Schema version: 32
#
# Table name: counselings
#
#  id                      :integer(11)   not null, primary key
#  zipcode                 :string(255)   
#  employment_start        :date          
#  employment_end          :date          
#  is_divorce_related      :boolean(1)    
#  is_survivorship_related :boolean(1)    
#  work_state_abbrev       :string(255)   
#  hq_state_abbrev         :string(255)   
#  pension_state_abbrev    :string(255)   
#  is_over_60              :boolean(1)    
#  monthly_income          :integer(11)   
#  number_in_household     :integer(11)   
#  employer_type_id        :integer(11)   
#  federal_plan_id         :integer(11)   
#  military_service_id     :integer(11)   
#  military_branch_id      :integer(11)   
#  military_employer_id    :integer(11)   
#  pension_earner_id       :integer(11)   
#  state_abbrev            :string(255)   <-- deprecated
#  county_id               :integer(11)   
#  city_id                 :integer(11)   
#

class Counseling < ActiveRecord::Base
  has_enumerated :pension_earner
  has_enumerated :employer_type
  has_enumerated :federal_plan
  has_enumerated :military_service
  has_enumerated :military_branch
  has_enumerated :military_employer
  belongs_to :city
  belongs_to :county
  belongs_to :work_state, :class_name => "State", :foreign_key => "work_state_abbrev"
  belongs_to :hq_state, :class_name => "State", :foreign_key => "hq_state_abbrev"
  belongs_to :pension_state, :class_name => "State", :foreign_key => "pension_state_abbrev"
  
  def matching_agencies
    agencies = case employer_type.name
    when 'State agency or office': state_plan_matches
    when 'County agency or office': state_plan_matches + county_plan_matches
    when 'City or other local government agency or office': state_plan_matches + 
                                          county_plan_matches + city_plan_matches
    else Array.new    
    end
    
    # always add AoA if we're in a coverage area
    # add dsps if AoA does not match
    if aoa_coverage
      agencies << aoa_coverage
    else
      agencies << matching_dsps
    end    
    agencies.flatten.uniq
  end
  
  def matching_dsps
    home_zip = Zip.find_by_zipcode(zipcode)
    home_state = home_zip.nil? ? '' : home_zip.state_abbrev
    sql = <<-SQL
        select distinct a.* from agencies a
        join locations l on l.agency_id = a.id
        join restrictions r on r.location_id = l.id
        join restrictions_states rs on rs.restriction_id = r.id 
              and rs.state_abbrev IN (?,?,?,?)
        where a.agency_category_id = ?
        SQL

    sql << 'and (r.minimum_age is not null or r.max_poverty is not null) '

    if is_over_60 == false
      sql << 'and r.minimum_age < 60 '
    end
    if poverty_level
      sql << "and r.max_poverty >= #{poverty_level.to_i} "
    end

    Agency.find_by_sql([sql, work_state_abbrev, hq_state_abbrev, pension_state_abbrev, 
                             home_state, AgencyCategory['Service Provider']])
  end
  
  def aoa_coverage
    home_zip = Zip.find_by_zipcode(zipcode)
    home_state = home_zip.nil? ? '' : home_zip.state_abbrev
    sql = <<-SQL
        select a.* from agencies a 
        join locations l on l.agency_id = a.id 
        join restrictions r on r.location_id = l.id or r.agency_id = a.id 
        join restrictions_states rs on rs.restriction_id = r.id 
        where a.result_type_id = ? and rs.state_abbrev IN (?,?,?,?)
        SQL
    Agency.find_by_sql([sql, ResultType['AoA'], work_state_abbrev, 
                        hq_state_abbrev, pension_state_abbrev, home_state])
  end
  
  def poverty_level
    # TODO: lookup poverty level from monthly_income and number_in_household
    monthly_income ? 1.25 : nil
  end
  
  def state_abbrev
    raise ArgumentError, 'state_abbrev is deprecated'
  end
  
  #######
  private
  #######
  
  def state_plan_matches
    sql = <<-SQL
        select distinct a.*
        from agencies a
        join plans p on p.agency_id = a.id
        join restrictions r on r.plan_id = p.id
        join restrictions_states rs on rs.restriction_id = r.id
        left join restrictions_counties rc on rc.restriction_id = r.id
        left join restrictions_cities rci on rci.restriction_id = r.id
        where rc.county_id is null
        and rci.city_id is null
        and a.agency_category_id = 3
        and rs.state_abbrev = ?
        SQL
    Agency.find_by_sql([sql, work_state_abbrev])
  end

  def county_plan_matches
    sql = <<-SQL
        select distinct a.*
        from agencies a
        join plans p on p.agency_id = a.id
        join restrictions r on r.plan_id = p.id
        join restrictions_counties rc on rc.restriction_id = r.id
        left join restrictions_cities rci on rci.restriction_id = r.id
        where rci.city_id is null
        and a.agency_category_id = 3
        and rc.county_id = ?
        SQL
    Agency.find_by_sql([sql, county_id])
  end

  def city_plan_matches
    sql = <<-SQL
        select distinct a.*
        from agencies a
        join plans p on p.agency_id = a.id
        join restrictions r on r.plan_id = p.id
        join restrictions_cities rc on rc.restriction_id = r.id
        where a.agency_category_id = 3 
        and rc.city_id = ?
        SQL
    Agency.find_by_sql([sql, city_id])
  end
   
end
