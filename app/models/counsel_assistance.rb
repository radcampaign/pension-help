class CounselAssistance

  def self.states
    State.all.collect{|s| [s.name, s.abbrev]}.delete_if { |opt| opt[1] == "AA" || opt[1] == "AE" or opt[1] == "AP" }.sort.push(["I don't know", "XX"])
  end

  def self.employer_types
    EmployerType.order(position: :asc).collect{|et| [et.name, et.id]}
  end

  def self.top_federal_plans
    FederalPlan.where(parent_id:nil).order(position: :asc).collect{|fp| [fp.name, fp.id]}
  end

  def self.military_service_types
    MilitaryService.where(is_active:true).order(position: :asc).collect{|ms| [ms.name, ms.id]}
  end

  def self.military_employer_types
    MilitaryEmployer.order(position: :asc).collect{|me| [me.name, me.id]}
  end

  def self.military_branches
    MilitaryBranch.order(position: :asc).collect{|mb| [mb.name, mb.id]}
  end

  def self.national_guard_branches
    results=MilitaryBranch.order(position: :asc).collect{|mb| [mb.name, mb.id]}
    results.delete_if {|item| [2,4,5,6,8].include?(item[1])}  # remove all by army, air force, I don't know
  end

  def self.pension_earner_choices
    PensionEarner.order(position: :asc).collect{|pe| [pe.name, pe.id]}
  end

  def self.farm_credit_plans
    Counseling.farm_credit_plan_matches.collect{|fcp| [fcp.name, fcp.id] } << ["I don't know", "IDK"] << ["Other", "OTHER"]
  end

  def self.civilian_plans
    Plan.joins(:plan_category).where(plan_categories: {name: 'Civilian Employee (NAF and other)'}).collect{|cp| [cp.name,cp.id]}
  end

end
