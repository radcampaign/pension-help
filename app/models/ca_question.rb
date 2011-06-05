class CAQuestion

  attr_accessor :header,
                :text,
                :desc,
                :object,
                :method,
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
      @object = p[:object]
      @method = p[:method]
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
        when 4 # Federal agency
         CAQuestion.new(:header => "Which retirement plan do you have a question about?",
                        :text => "There are many different retirement plans for federal employees.  Use the menu to select the federal retirement plan you are asking about.",
                        :desc => "Federal plan",
                        :object => "counseling",
                        :method => "federal_plan_id",
                        :controller => "help",
                        :action => "show_third_question",
                        :options => CounselAssistance.top_federal_plans)
        when 5 # Military service
         CAQuestion.new(:header => "Which retirement plan do you have a question about?",
                        :text => "There are many different retirement plans for members and employees of the Uniformed Services. Use the menu to select the type of retirement plan you are asking about:",
                        :desc => "Military service",
                        :object => "counseling",
                        :method => "military_service_id",
                        :controller => "help",
                        :action => "show_fourth_question",
                        :options => CounselAssistance.military_service_types)
        when 6 # State
          CAQuestion.new(:header => "Where were you employed?",
                         :text => "Use the menu below to select the state that offered the pension or retirement savings plan you have a question about.",
                         :desc => "State",
                         :object => "counseling",
                         :method => "work_state_abbrev",
                         :controller => "help",
                         :action => "show_available_plans",
                         :options => CounselAssistance.states)

         when 7 # County
          CAQuestion.new(:header => "Where were you employed?",
                         :text => "Use the menu below to select the state and then the county that offered the pension or retirement savings plan you have a question about.",
                         :desc => "State",
                         :object => "counseling",
                         :method => "work_state_abbrev",
                         :controller => "help",
                         :action => "show_fourth_question",
                         :options => CounselAssistance.states,
                         :county => true)

         when 8 # Locality
          CAQuestion.new(:header => "Where were you employed?",
                         :text => "Use the menu below to select the state and then the county and locality that offered the pension or retirement savings plan you have a question about.",
                         :desc => "State",
                         :object => "counseling",
                         :method => "work_state_abbrev",
                         :controller => "help",
                         :action => "show_fourth_question",
                         :options => CounselAssistance.states,
                         :county => true,
                         :local => true)
           when 10 # Farm Credit
            CAQuestion.new(:header => "Which Farm Credit plan do you have a question about?",
                           :text => "There are many retirement plans throughout the Farm Credit System.  Use the menu to select the Farm Credit plan you are asking about.",
                           :desc => "Farm Credit plan",
                           :object => "counseling",
                           :method => "selected_plan_id",
                           :controller => "",
                           :action => "",
                           :options => CounselAssistance.farm_credit_plans)
        else nil
      end #case
    elsif type=='PLANS'
      # state/county/local selected. Show available plans
      true # question is defined in partial
    else
      # not coming here from emp_type drop down or state/local,
      if counseling.employer_type_id == EMP_TYPE[:military]
        case counseling.military_service_id
          when 6 # Uniformed services member plans
            CAQuestion.new(:header => "Member plans",
                           :text => "Please select the appropriate uniformed service branch from the menu below.",
                           :desc => "Member plans",
                           :object => "counseling",
                           :method => "military_employer_id",
                           :controller => "",
                           :action => "",
                           :options => CounselAssistance.military_employer_types)
          when 8 # Civilian employee (NAF and other) plans
            #includes: uniformed service, ready reserve, national guard, and 'I don't know'
            CAQuestion.new(:header => "Member plans",
                           :text => "Please select the appropriate uniformed service branch from the menu below.",
                           :desc => "Uniformed service",
                           :object => "counseling",
                           :method => "selected_plan_id",
                           :controller => "",
                           :action => "",
                           :options => CounselAssistance.civilian_plans)
          else
            #includes: Military Court of Appeals Judges plans 'I don't know'
            nil
        end #case
      elsif counseling.employer_type_id = EMP_TYPE[:federal]
        child_plans = FederalPlan.find(:all, :conditions => {:parent_id => counseling.federal_plan_id}, :order => :position)
        if !child_plans.empty?
          CAQuestion.new(:header => "",
                         :text => "",
                         :desc => FederalPlan.find(counseling.federal_plan_id).name,
                         :object => "counseling",
                         :method => "federal_plan_id",
                         :controller => "help",
                         :action => type == 'THIRD_QUESTION' ? 'show_fourth_question' : 'show_fifth_question',
                         :options => child_plans.collect{|cp| [cp.name, cp.id]} << ["I don't know", "IDK"] << ["Other", "OTHER"] )
         else
           nil
         end

      end
    end
  end


end