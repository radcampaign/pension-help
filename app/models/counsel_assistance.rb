class CounselAssistance

  def self.states
    State.find(:all).collect{|s| [s.name, s.abbrev]}.sort
  end

  def self.employer_types
    EmployerType.find(:all, :order => 'position ASC').collect{|et| [et.name, et.id]}
  end
  
  def self.government_plans
    FederalPlan.find(:all, :order => 'position ASC').collect{|fp| [fp.name, fp.id]}
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
  
  def self.pension_earner_choices
    PensionEarner.find(:all, :order => 'position ASC').collect{|pe| [pe.name, pe.id]}
 end
 
end
