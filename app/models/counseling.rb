# == Schema Information
# Schema version: 41
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
#  created_at              :datetime      
#  is_afscme_member        :boolean(1)    
#  selected_plan_id        :integer(11)   
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

  validates_presence_of :employer_type

  #if Employer type = State Agency or Office
  validates_presence_of :work_state,
    :if => Proc.new { |c| (c.step == '2a') && (c.employer_type == EmployerType[6] || c.employer_type == EmployerType[7] || c.employer_type == EmployerType[8])}
  # if income is entered, then number_in_household must be entered along with it (ok to leave both income and household blank)
  validates_numericality_of :number_in_household, 
    :if => Proc.new {|c| c.step == 4 && (!c.monthly_income_tmp.blank? || !c.yearly_income_tmp.blank?)}
  validates_format_of :monthly_income_tmp,
    :with => /^\$?((\d+)|(\d{1,3}(,\d{3})+))(\.\d{2})?$/,
    :message => "^Monthly income doesn't seem to be a valid amount",
    :if => Proc.new {|c| c.step == 4 && !c.is_over_60 && !c.monthly_income_tmp.blank?}
  validates_format_of :yearly_income_tmp,
    :with => /^\$?((\d+)|(\d{1,3}(,\d{3})+))(\.\d{2})?$/,
    :message => "^Yearly income doesn't seem to be a valid amount",
    :if => Proc.new {|c| c.step == 4 && !c.is_over_60 && !c.yearly_income_tmp.blank?}
  # see also validate method below

  attr_accessor :monthly_income_tmp, :yearly_income_tmp, :step

  def employment_cutoff
    @employment_cutoff
  end
  def employment_cutoff=(employment_cutoff)
    @employment_cutoff = employment_cutoff
  end

  def yearly_income
    @yearly_income
  end
  def yearly_income=(yearly_inc)
    @yearly_income = yearly_inc
    self.monthly_income = yearly_inc.to_i / 12 if !yearly_inc.blank?
  end

  def step=(step)
    @step=step
  end
  def step
    @step || 0
  end

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

  #List of all AoA agencies.
  def aoa_coveraged_states
    sql = <<-SQL
      select
        s.abbrev
      from
        states as s join restrictions_states as rs on s.abbrev = rs.state_abbrev
        join restrictions as r on r.id = rs.restriction_id
        join locations as l on l.id = r.location_id and l.is_provider = 1
        join agencies as a on a.id = l.agency_id
      where a.result_type_id = ?
        and a.use_for_counseling = 1 and a.is_active = 1
        SQL
     State.find_by_sql([sql, ResultType['AoA']])
  end

  def aoa_coverage
    sql = <<-SQL
        select a.* from agencies a 
        join locations l on l.agency_id = a.id and l.is_provider = 1
        join restrictions r on r.location_id = l.id or r.agency_id = a.id 
        join restrictions_states rs on rs.restriction_id = r.id 
        where a.result_type_id = ? and rs.state_abbrev IN (?,?,?,?)
        and a.use_for_counseling = 1 and is_active = 1
        SQL
    Agency.find_by_sql([sql, ResultType['AoA'], work_state_abbrev, 
                        hq_state_abbrev, pension_state_abbrev, home_state])
  end

  #Conditions met to show step_5 
  def show_step5?
    #checking conditions
    ask_afscme = [6,7,8].include?(employer_type_id)
    not_aoa_covered = aoa_coverage.empty?
    #either age not answered or not over 60
    age_cond = is_over_60.blank? || !is_over_60
    #monthly_income not answered or not over poverty threshold
    income_cond = monthly_income.blank? || income_below_threshold?

    return (ask_afscme && not_aoa_covered && age_cond && income_cond)
  end

  def state_abbrev
    raise ArgumentError, 'state_abbrev is deprecated'
  end

  def age_restrictions?                   
    Agency.age_restrictions?(work_state_abbrev, hq_state_abbrev, pension_state_abbrev, home_state)
  end
  
  def income_restrictions?
    Agency.income_restrictions?(work_state_abbrev, hq_state_abbrev, pension_state_abbrev, home_state)
  end

  #######
#  private
  #######
  
  def home_state
    home_zip = ZipImport.find(zipcode) unless zipcode.blank?
    return home_zip.nil? ? '' : home_zip.state_abbrev
  end

  def poverty_level
    return nil unless number_in_household && monthly_income
    hh = number_in_household
    hh = 8 if hh > 8
    geo = home_state || 'US'
    geo = 'US' unless geo == 'HI' or geo == 'AK'
    sql = <<-SQL
      select 100 * (?/fpl) as value from poverty_levels
      where number_in_household = ? and geographic = ? order by year desc
      SQL
    return Agency.find_by_sql([sql, monthly_income*12, hh, geo]).first.value
  end
  
  def aoa_afscme_dsp
    if aoa_coverage.empty?
      ((is_afscme_member ? result_type_match('AFSCME') : nil) || Array.new) << (closest_dsp ? closest_dsp : result_type_match('NPLN'))
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
    nsp = closest_nsp
    dsp = closest_dsp
    agencies << nsp
    agencies << dsp
    if employment_end.nil? or employment_end < d
      agencies << result_type_match('DOL')
    else
      agencies << result_type_match('IRS')
    end
    agencies << result_type_match('PBGC')  
    agencies << result_type_match('NPLN') unless nsp or dsp
    agencies.flatten.uniq
  end
  
  def religious_matches
    agencies = Array.new
    agencies << result_type_match('IRS')
    unless aoa_coverage.empty?
      return agencies << aoa_coverage
    end
    dsp = closest_dsp
    agencies << dsp
    agencies << result_type_match('DOL')
    agencies << result_type_match('PBGC')
    agencies << result_type_match('NPLN') unless dsp
    agencies.flatten.uniq
  end

  def railroad_matches
    agencies = Array.new
    agencies << result_type_match('RRB')
    unless aoa_coverage.empty?
      return agencies << aoa_coverage
    end
    dsp = closest_dsp
    agencies << dsp
    agencies << result_type_match('SSA')
    agencies << result_type_match('NPLN') unless dsp
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
      dsp = closest_dsp
      agencies << dsp    
      agencies << result_type_match('OPM')
    else  
      agencies << result_type_match('OPM')
      unless aoa_coverage.empty?
        return agencies << aoa_coverage
      end
      agencies << result_type_match('NARFE')
      dsp = closest_dsp
      agencies << dsp    
      agencies << tsp_by_date
    end
    agencies << result_type_match('NPLN') unless dsp
    agencies.flatten.uniq
  end
  
  def military_matches
    agencies = Array.new
    if !pension_earner.nil? && pension_earner.name.include?("spouse") and
          (is_divorce_related? or is_survivorship_related?)
      agencies << result_type_match('DFAS')
      unless aoa_coverage.empty?
        return agencies << aoa_coverage
      end
      agencies << result_type_match('EXPOSE')
      dsp = closest_dsp
      agencies << dsp    
      agencies << tsp_by_date  
    else
      agencies << military_branch_match
      unless aoa_coverage.empty?
        return agencies << aoa_coverage
      end
      dsp = closest_dsp
      agencies << dsp    
      agencies << result_type_match('DFAS')
      agencies << tsp_by_date
    end
    agencies << result_type_match('NPLN') unless dsp
    agencies.flatten.uniq    
  end
  
  def closest_dsp
    return nil unless zipcode
    
    conditions = "a.agency_category_id=#{AgencyCategory['Service Provider'].id}
                   and (r.minimum_age is not null or r.max_poverty is not null) 
                   and addresses.address_type='dropin'
                   and addresses.latitude is not null
                   and rs.state_abbrev IN (?,?,?,?)"
                   
    if is_over_60 and !poverty_level.nil?
      conditions << "and (r.minimum_age >= 60 or r.max_poverty >= #{poverty_level.to_f})" 
    elsif is_over_60
      conditions << 'and r.minimum_age >= 60 '
    elsif !poverty_level.nil?
      conditions << "and r.max_poverty >= #{poverty_level.to_f} "
    else
      # didn't answer question - don't return any age/income-restricted results
      conditions << 'and r.minimum_age is null and r.max_poverty is null '  
    end
    
    address = Address.find(:first, :origin => ZipImport.find(zipcode), :order => 'distance',
            :joins => 'join locations l on addresses.location_id = l.id 
                                             and l.is_provider = 1
                       join agencies a on l.agency_id = a.id and a.use_for_counseling=1 and is_active=1
                       join restrictions r on r.location_id = l.id
                       join restrictions_states rs on rs.restriction_id = r.id',
            :conditions => [conditions, work_state_abbrev, hq_state_abbrev,
                            pension_state_abbrev, home_state])
    return address.location.agency unless address.nil?
  end

  def closest_nsp
    return nil unless zipcode

    address = Address.find(:first, :origin => ZipImport.find(zipcode), :order => 'distance',
	    :include => :location,
            :joins => 'join locations l on addresses.location_id = l.id 
                                             and l.is_provider = 1
                      join agencies a on l.agency_id = a.id and a.use_for_counseling=1 and a.is_active=1
                      left join restrictions r on r.location_id = l.id',
            :conditions => "a.agency_category_id=#{AgencyCategory['Service Provider'].id}
                           and (a.result_type_id is null or a.result_type_id=999)
                           and ((r.minimum_age is null and r.max_poverty is null) 
                           or r.id is null)
                           and addresses.address_type='dropin'
                           and addresses.latitude is not null")
    if address
      # create a new agency with just this one location (to avoid returning the 'wrong' location from the agency)
      a=Agency.new
      a.attributes=address.location.agency.attributes
      a.locations << address.location
    end
    return a
  end
  
  def state_plan_matches
    return [Plan.find(selected_plan_id).agency] if selected_plan_id
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
        and a.use_for_counseling = 1 and is_active = 1
        SQL
    Agency.find_by_sql([sql, work_state_abbrev])
  end

  def county_plan_matches
    return [nil] if selected_plan_id
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
        and a.use_for_counseling = 1 and is_active = 1
        SQL
    Agency.find_by_sql([sql, county_id])
  end

  def city_plan_matches
    return [nil] if selected_plan_id
    sql = <<-SQL
        select distinct a.*
        from agencies a
        join plans p on p.agency_id = a.id
        join restrictions r on r.plan_id = p.id
        join restrictions_cities rc on rc.restriction_id = r.id
        where a.agency_category_id = 3 
        and rc.city_id = ?
        and a.use_for_counseling = 1 and is_active = 1
        SQL
    Agency.find_by_sql([sql, city_id])
  end
  
  def tsp_by_date
    if !employment_end.nil? and employment_end > Date.new(1987,4,1)
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
      when 'Marine Corps':
                          result_type_match('USMCP')
      when 'National Oceanic and Atmospheric Administration Commissioned Corps':
                          result_type_match('OPMOSB')
      when 'U.S. Public Health Service Commissioned Corps':
                          result_type_match('PHSRC')
      when 'I don&rsquo;t know':
                          result_type_match('RSO')
  end
  end
  
  def result_type_match(type)
    return nil if ResultType[type].nil?
    Agency.find(:all, :conditions => ['result_type_id = ? and use_for_counseling = 1 and is_active = 1', ResultType[type]])
  end

  protected
  def before_validation
    if !self.yearly_income_tmp.blank?
      self.monthly_income = self.yearly_income_tmp.gsub(/[^0-9.]/, '' )
    elsif !self.monthly_income_tmp.blank?
      self.monthly_income = self.monthly_income_tmp.gsub(/[^0-9.]/, '' )
    end
  end
  def validate
    errors.add :zipcode if(!zipcode.blank? && !ZipImport.find(zipcode) rescue true)
    errors.add(:zipcode, 'is required') if zipcode.blank? && step > 1
    errors.add(:employment_end, 'date is required') if step == 3 && employer_type_id == 1 && employment_end.blank?
    errors.add(:employment_cutoff, 'date is required') if step == 3 && [4,5].include?(employer_type_id) && employment_cutoff.blank?
  end

  private
  #Checks if given monthly income is below poverty threshold
  def income_below_threshold?
    p_level = poverty_level

    unless p_level.nil?
      #Age should be null or less than 60
      query =<<END_QUERY
        select
          a.id, a.name
        from
          agencies as a join locations as l on a.id = l.agency_id and a.use_for_counseling=1 and is_active=1
          join addresses as ad on ad.location_id = l.id
          join restrictions as r on r.location_id = l.id and l.is_provider = 1
          join restrictions_states as rs on rs.restriction_id = r.id
        where
          a.agency_category_id=#{AgencyCategory['Service Provider'].id}
          and (r.minimum_age is null or r.minimum_age < 60 or r.max_poverty is null) 
          and ad.address_type='dropin'
          and rs.state_abbrev IN (?,?,?,?)
          and r.max_poverty > #{p_level}
END_QUERY
      Agency.find_by_sql([query, work_state_abbrev, hq_state_abbrev,
                              pension_state_abbrev, home_state ]).size > 0
    else
      nil
    end
  end
end
