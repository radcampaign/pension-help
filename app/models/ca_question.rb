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

  def initialize(attributes)
    attributes.each do |key, value|
      send(:"#{key}=", value)
    end
  end

  def self.get_next(counseling, type = nil)

    if type == "EMP_TYPE"
      case counseling.employer_type_id
        when 4
          CAQuestion.new(
              :desc => "Which retirement plan do you have a question about?",
              :object => "counseling",
              :method => "federal_plan_id",
              :controller => "help",
              :action => "show_third_question",
              :options => CounselAssistance.top_federal_plans
          )

        when 5
          CAQuestion.new(
              :desc => "Which retirement plan do you have a question about?",
              :object => "counseling",
              :method => "military_service_id",
              :controller => "help",
              :action => "show_fourth_question",
              :options => CounselAssistance.military_service_types
          )

        when 6
          CAQuestion.new(
              :desc => "In what U.S. state or territory is your employer located?",
              :object => "counseling",
              :method => "work_state_abbrev",
              :controller => "help",
              :action => "show_available_plans",
              :options => CounselAssistance.states
          )

        when 7
          CAQuestion.new(
              :desc => "In which state or U.S. territory is your employer located?",
              :object => "counseling",
              :method => "work_state_abbrev",
              :controller => "help",
              :action => "show_fourth_question",
              :options => CounselAssistance.states,
              :county => true
          )

        when 8
          CAQuestion.new(
              :desc => "In which U.S. state or territory is your employer located?",
              :object => "counseling",
              :method => "work_state_abbrev",
              :controller => "help",
              :action => "show_fourth_question",
              :options => CounselAssistance.states,
              :county => true,
              :local => true
          )

        when 10
          CAQuestion.new(
              :desc => "Which Farm Credit plan do you have a question about?",
              :object => "counseling",
              :method => "selected_plan_id",
              :controller => "",
              :action => "",
              :options => CounselAssistance.farm_credit_plans
          )
        else
          nil
      end
    elsif type == 'PLANS'
      true
    else
      if counseling.employer_type_id == EMP_TYPE[:military]
        case counseling.military_service_id
          when 6
            CAQuestion.new(
                :desc => "Member plans",
                :object => "counseling",
                :method => "military_branch_id",
                :controller => "",
                :action => "",
                :options => CounselAssistance.military_branches
            )

          when 8
            CAQuestion.new(
                :desc => "Uniformed service",
                :object => "counseling",
                :method => "selected_plan_id",
                :controller => "",
                :action => "",
                :options => CounselAssistance.civilian_plans
            )
          else
            nil
        end
      elsif counseling.employer_type_id = EMP_TYPE[:federal]
        child_plans = FederalPlan.where(parent_id: counseling.federal_plan_id).order(position: :asc)
        if !child_plans.empty?
          CAQuestion.new(
              :desc => FederalPlan.find(counseling.federal_plan_id).name,
              :object => "counseling",
              :method => "federal_plan_id",
              :controller => "help",
              :action => type == 'THIRD_QUESTION' ? 'show_fourth_question' : 'show_fifth_question',
              :options => child_plans.collect { |cp| [cp.name, cp.id] } << ["I don't know", "IDK"] << ["Other", "OTHER"])
        else
          nil
        end
      end
    end
  end
end