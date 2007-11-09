class CAQuestion
  
  attr_accessor :header,
                :text,
                :desc,
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
      @controller = p[:controller]   
      @action = p[:action]   
      @options = p[:options]
      @state = p[:state]  
      @county = p[:county]  
      @local = p[:local]  
  end
  
  def self.find(id)
    case id
      when "PRV_EMP"
        CAQuestion.new(:header => "What type of private employer?",
                       :text => "Make the menu selection that best describes the private employer offering the pension or retirement savings plan you have a question about.",
                       :desc => "Private employer",
                       :controller => "help",
                       :action => "show_third_question",
                       :options => CounselAssistance.private_employer_types)
      when "GOV_EMP"  
        CAQuestion.new(:header => "What type of government employer?",
                       :text => "Make the menu selection that best describes the government employer offering the pension or retirement savings plan you have a question about.",
                       :desc => "Government employer",
                       :controller => "help",
                       :action => "show_third_question",
                       :options => CounselAssistance.government_employer_types)
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
                      
      when "ST_PLAN"  
       CAQuestion.new(:header => "Which state plan do you have a question about?",
                      :text => "There are different retirement plans for state employees.  Use the menus below to select the state that offered the pension or retirement savings plan you have a question about; and the most recent type of state employment that earned the benefit.",
                      :desc => "Available Plans",
                      :controller => "help",
                      :action => "show_fourth_question",
                      :options => CounselAssistance.local_plans,
                      :state => true)
      when "CO_PLAN"  
       CAQuestion.new(:header => "Which county plan do you have a question about?",
                      :text => "There are different retirement plans for county employees.  Use the menus below to select the county that offered the pension or retirement savings plan you have a question about; and the most recent type of county employment that earned the benefit.",
                      :desc => "Available Plans",
                      :controller => "help",
                      :action => "show_fourth_question",
                      :options => CounselAssistance.local_plans,
                      :state => true,
                      :county => true)
      when "LOC_PLAN"  
       CAQuestion.new(:header => "Which city or other local government plan do you have a question about?",
                      :text => "There are many different retirement plans for employees of cities and other local governments.  Use the menus below to select the city or other local government that offered the pension or retirement savings plan you have a question about; and the most recent type of employment that earned the benefit.",
                      :desc => "Available Plans",
                      :controller => "help",
                      :action => "show_fourth_question",
                      :options => CounselAssistance.local_plans,
                      :state => true,
                      :county => true,
                      :local => true)
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