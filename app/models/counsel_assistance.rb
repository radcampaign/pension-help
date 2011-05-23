class CounselAssistance

  def self.states
    State.find(:all).collect{|s| [s.name, s.abbrev]}.delete_if { |opt| opt[1] == "AA" || opt[1] == "AE" or opt[1] == "AP" }.sort
  end

  def self.employer_types
    EmployerType.find(:all, :order => 'position ASC').collect{|et| [et.name, et.id]}
  end

  def self.top_federal_plans
    FederalPlan.find(:all, :conditions => {:parent_id => nil}, :order => 'position ASC').collect{|fp| [fp.name, fp.id]}
  end

  def self.military_service_types
    MilitaryService.find(:all, :order => 'position ASC').collect{|ms| [ms.name, ms.id]}
  end

  def self.military_employer_types
    MilitaryEmployer.find(:all, :order => 'position ASC').collect{|me| [me.name, me.id]}
  end

  def self.uniformed_service_branches
    MilitaryBranch.find(:all, :order => 'position ASC').collect{|mb| [mb.name, mb.id]}
  end

  def self.national_guard_branches
    results=MilitaryBranch.find(:all, :order => 'position ASC').collect{|mb| [mb.name, mb.id]}
    results.delete_if {|item| [2,4,5,6,8].include?(item[1])}  # remove all by army, air force, I don't know
  end

  def self.pension_earner_choices
    PensionEarner.find(:all, :order => 'position ASC').collect{|pe| [pe.name, pe.id]}
  end

  def self.farm_credit_plans
    Counseling.farm_credit_plan_matches.collect{|fcp| [fcp.name, fcp.id] } << ["I don't know", "IDK"] << ["Other", "OTHER"]
  end

end
