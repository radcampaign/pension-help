# == Schema Information
# Schema version: 33
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
#  state_abbrev            :string(255)   
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
  has_one :selected_plan, :class_name => "Plan"
  
  def matching_agencies
    agencies = case employer_type.name
    when 'Company or nonprofit':     company_matches
    when 'Railroad':                 railroad_matches
    when 'Religious institution':    religious_matches
    when 'Federal agency or office': federal_matches
    when 'Military':                 military_matches
    when 'State agency or office':   state_plan_matches + aoa_afscme_dsp
    when 'County agency or office':  state_plan_matches + county_plan_matches + aoa_afscme_dsp
    when 'City or other local government agency or office': state_plan_matches +  
                                     county_plan_matches + city_plan_matches + aoa_afscme_dsp
    else Array.new    
    end
    
    agencies.flatten.uniq.compact
  end
  
  def matching_dsps
    sql = <<-SQL
        select distinct a.* from agencies a
        join locations l on l.agency_id = a.id
        join restrictions r on r.location_id = l.id
        join restrictions_states rs on rs.restriction_id = r.id 
              and rs.state_abbrev IN (?,?,?,?)
        where a.agency_category_id = ?
        and a.use_for_counseling = 1
        SQL

    sql << 'and (r.minimum_age is not null or r.max_poverty is not null) '

    if is_over_60 == false
      sql << 'and r.minimum_age < 60 '
    end
    if poverty_level
      sql << "and r.max_poverty >= #{poverty_level.to_f} "
    end

    Agency.find_by_sql([sql, work_state_abbrev, hq_state_abbrev, pension_state_abbrev, 
                             home_state, AgencyCategory['Service Provider']])
  end
  
  def aoa_coverage
    sql = <<-SQL
        select a.* from agencies a 
        join locations l on l.agency_id = a.id 
        join restrictions r on r.location_id = l.id or r.agency_id = a.id 
        join restrictions_states rs on rs.restriction_id = r.id 
        where a.result_type_id = ? and rs.state_abbrev IN (?,?,?,?)
        and a.use_for_counseling = 1
        SQL
    Agency.find_by_sql([sql, ResultType['AoA'], work_state_abbrev, 
                        hq_state_abbrev, pension_state_abbrev, home_state])
  end
  
  def state_abbrev
    raise ArgumentError, 'state_abbrev is deprecated'
  end
    
  #######
#  private
  #######
  
  def home_state
    home_zip = Zip.find_by_zipcode(zipcode)
    return home_zip.nil? ? '' : home_zip.state_abbrev
  end

  def poverty_level
    return nil unless number_in_household && monthly_income
    hh = number_in_household
    hh = 8 if hh > 8
    geo = home_state || 'US'
    geo = 'US' unless geo == 'HI' or geo == 'AK'
    sql = <<-SQL
      select ?/fpl as value from poverty_levels
      where number_in_household = ? and geographic = ?
      SQL
    return Agency.find_by_sql([sql, monthly_income*12, hh, geo]).first.value
  end
  
  def aoa_afscme_dsp
    if aoa_coverage.empty?
      (result_type_match('AFSCME') || Array.new) << matching_dsps
    else
      aoa_coverage
    end
  end
  
  def company_matches
    agencies = Array.new
    d = Date.new(1976,1,1)
    if employment_end.nil? or employment_end < d
      agencies << result_type_match('IRS')
    else
      agencies << result_type_match('DOL')
    end
    unless aoa_coverage.empty?
      return agencies << aoa_coverage
    end
    # agencies << nsps
    agencies << matching_dsps
    if employment_end.nil? or employment_end < d
      agencies << result_type_match('DOL')
    else
      agencies << result_type_match('IRS')
    end
    agencies << result_type_match('PBGC')  
    agencies.flatten.uniq
  end
  
  def religious_matches
    agencies = Array.new
    agencies << result_type_match('IRS')
    unless aoa_coverage.empty?
      return agencies << aoa_coverage
    end
    agencies << matching_dsps
    agencies << result_type_match('DOL')
    agencies << result_type_match('PBGC')
    agencies.flatten.uniq
  end

  def railroad_matches
    agencies = Array.new
    agencies << result_type_match('RRB')
    unless aoa_coverage.empty?
      return agencies << aoa_coverage
    end
    agencies << matching_dsps
    agencies << result_type_match('SSA')
    agencies.flatten.uniq
  end
  
  def federal_matches
    agencies = Array.new
    if federal_plan.nil? or federal_plan.name == 'Thrift Savings Plan (TSP)'
      agencies << result_type_match('TSP')
      unless aoa_coverage.empty?
        return agencies << aoa_coverage
      end
      agencies << result_type_match('NARFE')
      agencies << matching_dsps
      agencies << result_type_match('OPM')
    else  
      agencies << result_type_match('OPM')
      unless aoa_coverage.empty?
        return agencies << aoa_coverage
      end
      agencies << result_type_match('NARFE')
      agencies << matching_dsps    
      agencies << tsp_by_date
    end
    agencies.flatten.uniq
  end
  
  def military_matches
    agencies = Array.new
    if is_divorce_related? and is_survivorship_related?
      agencies << result_type_match('DFAS')
      unless aoa_coverage.empty?
        return agencies << aoa_coverage
      end
      agencies << result_type_match('EXPOSE')
      agencies << matching_dsps   
      agencies << tsp_by_date  
    else
      agencies << military_branch_match
      unless aoa_coverage.empty?
        return agencies << aoa_coverage
      end
      agencies << matching_dsps   
      agencies << result_type_match('DFAS')
      agencies << tsp_by_date
    end
    agencies.flatten.uniq    
  end
  
  def nsps
    sql = <<-SQL
        select distinct a.* from agencies a
        join locations l on l.agency_id = a.id
        left join restrictions r on r.location_id = l.id
        left join restrictions_states rs on rs.restriction_id = r.id 
              and rs.state_abbrev IN (?,?,?,?)
        where a.agency_category_id = ?
        and a.use_for_counseling = 1
        and ((r.minimum_age is null and r.max_poverty is null) 
            or r.id is null)
        SQL

    Agency.find_by_sql([sql, work_state_abbrev, hq_state_abbrev, pension_state_abbrev, 
                             home_state, AgencyCategory['Service Provider']])
  end
  
  def state_plan_matches
    return [selected_plan.agency] if selected_plan
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
        and a.use_for_counseling = 1
        SQL
    Agency.find_by_sql([sql, work_state_abbrev])
  end

  def county_plan_matches
    return nil if selected_plan
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
        and a.use_for_counseling = 1
        SQL
    Agency.find_by_sql([sql, county_id])
  end

  def city_plan_matches
    return nil if selected_plan
    sql = <<-SQL
        select distinct a.*
        from agencies a
        join plans p on p.agency_id = a.id
        join restrictions r on r.plan_id = p.id
        join restrictions_cities rc on rc.restriction_id = r.id
        where a.agency_category_id = 3 
        and rc.city_id = ?
        and a.use_for_counseling = 1
        SQL
    Agency.find_by_sql([sql, city_id])
  end
  
  def tsp_by_date
    if employment_end.nil? or employment_end > Date.new(1987,4,1)
      return result_type_match('TSP')
    end
  end
  
  def military_branch_match
    return nil unless military_branch
    case military_branch.name
      when 'Army':        result_type_match('RSO')
      when 'Navy':        result_type_match('NRAO')
      when 'Air Force':   result_type_match('AFRSB')
      when 'Coast Guard': result_type_match('OHSPSC')
      when 'Marines':     result_type_match('USMCP')
      when 'National Oceanic and Atmospheric Administration Commissioned Corps':
                          result_type_match('OPMOSB')
      when 'U.S. Public Health Service Commissioned Corps':
                          result_type_match('PHSRC')
    end
  end
  
  def result_type_match(type)
    return nil if ResultType[type].nil?
    Agency.find(:all, :conditions => ['result_type_id = ? and use_for_counseling = 1', ResultType[type]])
  end
   
end
