class CounselAssistance

  def self.states
    State.find(:all).collect{|s| [s.name, s.abbrev]}.sort
  end

  def self.employer_types
    EmployerType.find(:all).collect{|et| [et.name, et.id]}
  end
  
  def self.government_plans
    FederalPlan.find(:all).collect{|fp| [fp.name, fp.id]}
  end
  
  def self.military_service_types
    MilitaryService.find(:all).collect{|ms| [ms.name, ms.id]}
  end
  
  def self.military_employer_types
    MilitaryEmployer.find(:all).collect{|me| [me.name, me.id]}
  end
  
  def self.uniformed_service_branches
    MilitaryBranch.find(:all).collect{|mb| [mb.name, mb.id]}
  end
  
  def self.pension_earner_choices
    PensionEarner.find(:all).collect{|pe| [pe.name, pe.id]}
 end
 
end
