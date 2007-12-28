class CAQuestion
  
  attr_accessor :header,
                :text,
                :desc,
                :name,
                :controller,
                :action,
                :options,
                :state,
                :county,
                :local
                
  def initialize(p)
      @header = p[:header]
      @text = p[:text]   
      @desc = p[:desc]             
      @name = p[:name]
      @controller = p[:controller]   
      @action = p[:action]   
      @options = p[:options]
      @state = p[:state]  
      @county = p[:county]  
      @local = p[:local]  
  end
  
  def self.get_next(counseling, type=nil)
    if type=='EMP_TYPE'
      case counseling.employer_type_id
        when 6 # State
          CAQuestion.new(:header => "Where were you employed?",
                         :text => "Use the menu below to select the state that offered the pension or retirement savings plan you have a question about.",
                         :desc => "State",
                         :name => "counseling[work_state_abbrev]",
                         :controller => "help",
                         :action => "show_fourth_question",
                         :options => CounselAssistance.states)

         when 7 # County
          CAQuestion.new(:header => "Where were you employed?",
                         :text => "Use the menu below to select the state and then the county that offered the pension or retirement savings plan you have a question about.",
                         :desc => "State",
                         :name => "counseling[work_state_abbrev]",
                         :controller => "help",
                         :action => "show_fourth_question",
                         :options => CounselAssistance.states,
                         :county => true)

         when 8 # Locality
          CAQuestion.new(:header => "Where were you employed?",
                         :text => "Use the menu below to select the state and then the county and locality that offered the pension or retirement savings plan you have a question about.",
                         :desc => "State",
                         :name => "counseling[work_state_abbrev]",
                         :controller => "help",
                         :action => "show_fourth_question",
                         :options => CounselAssistance.states,
                         :county => true,
                         :local => true)
        else nil
      end #case
    end 
  end
        
  def self.find(id)
    case id
      when "GOV_PLAN"  
       CAQuestion.new(:header => "Which federal plan do you have a question about?",
                      :text => "There are many different retirement plans for federal employees.  Use the menu to select the federal retirement plan you are asking about.",
                      :desc => "Federal plan",
                      :controller => "help",
                      :action => "show_fourth_question",
                      :options => CounselAssistance.government_plans)
      when "MIL_SRV"  
       CAQuestion.new(:header => "What type of military service or employment?",
                      :text => "There are different retirement plans for uniformed servicemen and civilian military employees.  Select the most recent type of military service or employment that earned the pension or retirement savings plan you have a question about.",
                      :desc => "Military service",
                      :controller => "help",
                      :action => "show_fourth_question",
                      :options => CounselAssistance.military_service_types)
    
      when "UNI_MIL"  
       CAQuestion.new(:header => "Which branch of service?",
                      :text => "Please select the appropriate uniformed service branch from the menu below.",
                      :desc => "Uniformed service",
                      :controller => "",
                      :action => "",
                      :options => CounselAssistance.uniformed_service_branches)
      when "CIVIL_MIL"
       CAQuestion.new(:header => "Which military employer?",
                      :text => "Make the menu selection that best describes the military employer offering the pension or retirement savings plan you have a question about.",
                      :desc => "Military employer",
                      :controller => "",
                      :action => "",
                      :options => CounselAssistance.military_employer_types) 
    end
  end
  
end