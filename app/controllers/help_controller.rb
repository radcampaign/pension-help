require "email"

class HelpController < ApplicationController
  before_filter :check_aoa_zip, :only => [:step3]
  before_filter :hide_email_button, :only => [
    :counseling, :step_2, :check_aoa_zip, :step_3, :step_4, :step_5
  ]
  before_filter :step_back
  before_filter :check_last_step, :only => :results

  def index
    show_content("help")
  end

  def resources
    show_content("help/resources")
  end

  def counseling
    if params.has_key?(:previous)
      @counseling = update_counseling({})
    else
      @counseling = session[:counseling] = Counseling.new
      @counseling.abc_path = 'B' # B was the winner of the a/b test --- everyone gets B now
    end
  end

  def show_second_question
    @counseling = update_counseling(params)
    @counseling.step = 1

    case @counseling.employer_type_id
    when 1..10
      @next_question = CAQuestion.get_next(@counseling, "EMP_TYPE")

      if @next_question
        @next_question.options = @next_question.options.delete_if { |opt|
          ["AA", "AE", "AP"].include?(opt[1])
        }
      end

      render :action => "show_second_question.rjs"
    else
      render :update do |page|
        page.redirect_to(:controller => 'help', :action => 'counseling')
      end
    end
  end

  # Remote function - Displays 3nd pulldown based on info submitted from 2nd pulldown
  def show_third_question
    @counseling = update_counseling(params)
    @counseling.step = 1
    @next_question = CAQuestion.get_next(@counseling, 'THIRD_QUESTION')
    render :update do |page|
      if @next_question
        @states = CounselAssistance.states if @next_question.state
        page.replace_html 'q3', :partial => 'next_question', :locals => {'question' => @next_question, 'selected_value' => nil}
        page.visual_effect :highlight, 'q3'
        page.replace_html 'q4', ''
      end
    end
  end

  # Remote function - Displays 4th pulldown based on info submitted from 3rd pulldown
  def show_fourth_question
    @counseling = update_counseling(params)
    @counseling.step = 1
    if @counseling[:federal_plan_id] == 5 # 'I don't know'
      # Don’t Know Federal Plan Loop
      render :update do |page|
        page.redirect_to(:controller => 'help', :action => 'federal_plan_descriptions')
      end
      return
    end

    @next_question = CAQuestion.get_next(@counseling, 'FOURTH_QUESTION')
    render :update do |page|
      if @next_question
        page.replace_html 'q4', :partial => 'next_question', :locals => {'question' => @next_question, 'selected_value' => nil}
        page.visual_effect :highlight, 'q4'
      else
        page.replace_html 'q4', nil
      end
    end
  end

  def show_fifth_question
    @counseling = update_counseling(params)
    render :nothing => true
  end

  def show_available_plans
    @counseling = update_counseling(params)
    @counseling.step = 1
    @matching_plans = @counseling.matching_plans.sort { |a, b| a.name <=> b.name } rescue []
    if @matching_plans.blank?
      # if @counseling.employer_type_id == EMP_TYPE[:state]
      #   self.get_after_plan_selection_questions
      # else
        render :update do |page|
          page.replace_html "q5", :partial => "other_plans"
          page.visual_effect :highlight, "q5"
        end
      # end
    else
      @show_option_other = [EMP_TYPE[:county], EMP_TYPE[:city]].include?(@counseling.employer_type_id)
      render :update do |page|
        page.replace_html "q5", :partial => "available_plans"
        page.visual_effect :highlight, "q5"
      end
    end
  end

  def step_2 #zip, AoA states, plan questions
    @zip_found = true
    @counseling = update_counseling(params)

    if !@counseling.valid?
      @options = CounselAssistance.employer_types
      render :action => "counseling"
    else
      @counseling.step = 1
      @states = CounselAssistance.states
      @ask_aoa = [EMP_TYPE[:company], EMP_TYPE[:railroad], EMP_TYPE[:religious],
                  EMP_TYPE[:federal], EMP_TYPE[:military], EMP_TYPE[:unknown]].include?(@counseling.employer_type_id)
    end

    @previous_to = "/help/counseling"
  end

  # ajax call to check if zipcode is in aoa coverage area
  def check_aoa_zip
    @counseling = update_counseling(params)

    @states = CounselAssistance.states
    @ask_aoa = [
      EMP_TYPE[:company],
      EMP_TYPE[:railroad],
      EMP_TYPE[:religious],
      EMP_TYPE[:federal],
      EMP_TYPE[:military],
      EMP_TYPE[:unknown],
      EMP_TYPE[:farm_credit]
    ].include?(@counseling.employer_type_id)

    if !@counseling.valid?
      @zip_found = false
      @show_aoa_expansion = false
    elsif @counseling.aoa_coverage.empty? && @ask_aoa &&
      (@counseling.hq_state_abbrev.blank? || @counseling.pension_state_abbrev.blank? || @counseling.work_state_abbrev.blank?)
      @aoa_states = @counseling.aoa_covered_states
      @zip_found = true
      @show_aoa_expansion = true

      if @counseling.step == "2a"
        @counseling.errors.add(:work_state_abbrev, "is required") if @counseling.work_state_abbrev.blank?
        @counseling.errors.add(:hq_state_abbrev, "is required") if @counseling.hq_state_abbrev.blank?
        @counseling.errors.add(:pension_state_abbrev, "is required") if @counseling.pension_state_abbrev.blank?
      end

      @counseling.step = "2a"
    else # good zip with AoA coverage, or good zip but no need to ask AoA questions
      if @counseling.aoa_coverage.empty?
        # clear out extra state dropdowns, as we won't consider them in this case
        @counseling.hq_state_abbrev = @counseling.pension_state_abbrev = nil

        # but preserve work_state if user is state/county/local employee
        unless [EMP_TYPE[:state], EMP_TYPE[:county], EMP_TYPE[:city]].include?(@counseling.employer_type_id)
          @counseling.work_state_abbrev = nil
        end
      end
      @zip_found = true
      @show_aoa_expansion = false

      redirect_to(:action => :step_3, :var => current_counseling.abc_path) and return
    end

    @previous_to = "/help/step_2"
    render :action => :step_2
  end

  def step_3
    @counseling = current_counseling
    if @counseling.employer_type_id == EMP_TYPE[:military]
      @options = CounselAssistance.pension_earner_choices
    else
      redirect_to(:action => :step_5, :var => current_counseling.abc_path) and return
    end
  end

  def process_step_3
    @counseling = update_counseling(params)
    @counseling.step = 3

    if @counseling.valid?
      redirect_to(:action => :step_5, :var => current_counseling.abc_path)
    else
      @options = CounselAssistance.pension_earner_choices
      render :template => 'help/step_3'
    end
  end

  def step_4
    @counseling = current_counseling

    @age_restrictions = @counseling.age_restrictions?
    @income_restrictions = @counseling.income_restrictions?

    if @counseling.aoa_coverage.empty? and (@age_restrictions || @income_restrictions)
      render :template => "help/step_4"
    else
      redirect_to(:action => :step_5, :var => current_counseling.abc_path)
    end
  end

  def process_step_4
    @counseling = update_counseling(params)
    @counseling.step = 4
    if @counseling.valid?
      redirect_to(:action => :step_5, :var => current_counseling.abc_path)
    else
      @age_restrictions = @counseling.age_restrictions? # put this in an instance variable so we don't have to call it again from the view
      @income_restrictions = @counseling.income_restrictions? # put this in an instance variable so we don't have to call it again from the view
      render :template => 'help/step_4'
    end
  end

  def step_5
    @counseling = current_counseling
    if (@counseling.show_step5?)
      render :template => 'help/step_5'
    else
      redirect_to :action => :results
    end
  end

  def process_step_5
    @counseling = update_counseling(params)
    @counseling.step = 5
    redirect_to :action => :results
  end

  def last_step
    get_previous_to_from_step
    @counseling = update_counseling({})
    @counseling.step = 10
  end

  def process_last_step
    @counseling = update_counseling(params)
    if @counseling.valid?
      redirect_to :action => :results
      @counseling.step = 11
    else
      @previous_to = params[:previous_to]
      render :action => "last_step"
    end
  end

  def results
    @counseling = current_counseling
    if @counseling.attributes.values.uniq.compact.empty?
      flash[:error] = "Please answer the following questions in order to find out which agencies can best assist you."
      redirect_to "/help/counseling"
    end
    @zip_import = ZipImport.find_by_zipcode(@counseling.zipcode)
    @results = @counseling.matching_agencies
    begin
      @currently_employed_text = Content.find_by_url('currently_employed_text').content
    rescue ActiveRecord::RecordNotFound
      nil # continue on if we don't find anything
    end
    @counseling.save
    if @counseling.selected_plan_id
      @results.each{|a| a.plans.delete_if {|p| p.id != @counseling.selected_plan_id.to_i &&
              a.agency_category_id==3}}
    end
    if [EMP_TYPE[:county], EMP_TYPE[:city] ].include?(@counseling.employer_type_id) &&
      @counseling.selected_plan_id.nil?
        @ask_user_for_email = true
    end

    @results
  end

  def email
    if !params[:email].blank?
      unless params[:email] =~ EMAIL_REGEX
        render :update do |page|
          page.hide "send-results-pending"
          page.show "send-results-btn"
          page.replace_html "resultsEmailResponse", "Invalid e-mail."
          page.visual_effect :highlight, "resultsEmailResponse"
        end
      else
        @counseling = Counseling.find params[:id]
        @results = @counseling.matching_agencies
        @lost_plan_resources = Content.find_by_url('lost_plan_resources').content rescue nil if  params[:lost_plan_request].to_s == "1"

        if params[:contact].to_s == "1"
          @counseling.feedback_email = params[:email]
          @counseling.save
          Mailer.deliver_unavailable_plan_feedback(@counseling)
        end

        Mailer.deliver_counseling_results(params[:email], @counseling, @results, @lost_plan_resources)

        render :update do |page|
          page.hide "send-results-pending"
          page.replace_html "resultsEmailResponse", "E-mail has been sent."
          page.visual_effect :highlight, "resultsEmailResponse"
        end
      end
    else
      render :update do |page|
        page.hide "send-results-pending"
        page.show "send-results-btn"
        page.replace_html "resultsEmailResponse", "Invalid e-mail address."
        page.visual_effect :highlight, "resultsEmailResponse"
      end
    end
  end

  # Used for populating state, county and local pulldowns
  def get_counties
    @counseling = update_counseling(params)
    counties = State.find(params[:counseling][:work_state_abbrev]).counties rescue []
    render :update do |page|
      page.replace_html "counties", :partial => "county_selector",
        :locals => {
          "options" => counties.collect { |c| [c.name, c.id] }.
            sort { |one, two| (one[0] == "I don't know" || two[0] == "I don't know") ? -1 : one[0] <=> two[0] },
          "cities" => params[:local] }
      page.visual_effect :highlight, 'county_container'
    end
  end

  def get_localities
    @counseling = update_counseling(params)

    localities = County.find(params[:counseling][:county_id]).cities rescue []
    render :update do |page|
      page.replace_html "localities", :partial => "city_selector",
        :locals => {
          "options" => localities.collect { |c| [c.name, c.id] }.
            sort { |one, two| (one[0] == "I don't know" || two[0] == "I don't know") ? -1 : one[0] <=> two[0] },
          "cities" => "false" }
      page.visual_effect :highlight, 'city_container'
    end
  end

  def get_after_plan_selection_questions
    @counseling = update_counseling(params)

    if params[:plan] == "IDK"
      counseling = update_counseling(params)
      employees = counseling.employee_list

      if @counseling.employer_type_id == 6 # State agency or office
        render :update do |page|
          page.replace_html 'question_container', :partial => 'employee_list', :layout => false, :locals => {'employees' => employees}
          page.visual_effect :highlight, 'question_container'
        end
      else
        render :update do |page|
          page.replace_html 'question_container', :partial => 'not_known_plans', :layout => false
          page.visual_effect :highlight, 'question_container'
        end
      end
    elsif params[:plan]=="OTHER"
      render :update do |page|
        page.replace_html 'question_container', :partial => 'other_plans', :layout => false
        page.visual_effect :highlight, 'question_container'
      end
    else
      render :update do |page|
        page.replace_html 'question_container', "&nbsp;"
      end
    end
  end


  protected

  def step_back
    if (params[:"previous.x"] || params[:"previous.y"]) && params[:previous_to]
      current_counseling.step = 0
      redirect_to("#{params[:previous_to]}?previous&var=#{current_counseling.abc_path}") and return
    end
  end

  def get_previous_to_from_step
    case current_counseling.step
    when 1
      @previous_to = "/help/step_2"
    when '2a'
      @previous_to = "/help/check_aoa_zip"
    else
      @previous_to = "/help/step_#{current_counseling.step}"
    end
  end

  def check_last_step
    if current_counseling.show_last_step_questions?
      redirect_to(:action => 'last_step', :var => current_counseling.abc_path) and return
    end
  end

  def show_content(url)
    @content = Content.find_by_url(url)
    render 'site/show_page'
  end

  def hide_email_button
    @hide_email_button = true
  end

  def current_counseling
    session[:counseling] ? session[:counseling] : Counseling.new
  end

  EARLIEST_EMPLOYMENT_YEAR = 1880
  LATEST_EMPLOYMENT_YEAR = 2025

  def update_counseling(data)
    counseling = current_counseling
    counseling.attributes = data[:counseling]

    if data[:counseling] && !data[:counseling][:yearly_income].blank?
      counseling.yearly_income = data[:counseling][:yearly_income]
    end

    if ["IDK", "OTHER", 0].include?(counseling.selected_plan_id)
      counseling.selected_plan_id = nil
    end

    if ["IDK", "OTHER", 0].include?(counseling.federal_plan_id)
      counseling.federal_plan_id = nil
    end

    if counseling.federal_plan_id && FederalPlan.find(counseling.federal_plan_id).associated_plan_id
      counseling.selected_plan_id = counseling.federal_plan.associated_plan_id
    end

    if !data[:selected_plan_override].blank?
      counseling.selected_plan_id = data[:selected_plan_override]
    end

    if data[:employment_start_year] && data[:employment_start_year].to_i > EARLIEST_EMPLOYMENT_YEAR && data[:employment_start_year].to_i < LATEST_EMPLOYMENT_YEAR
      counseling.employment_start = Date.new(data[:employment_start_year].to_i, 1, 1)
    end

    if data[:employment_end_year] && data[:employment_end_year].to_i > EARLIEST_EMPLOYMENT_YEAR && data[:employment_end_year].to_i < LATEST_EMPLOYMENT_YEAR
      counseling.employment_end = Date.new(data[:employment_end_year].to_i, 1, 1)
    end

    if counseling.currently_employed.nil? && !counseling.employment_end.nil? && counseling.employment_end.year < Time.now.year
      counseling.currently_employed = false
    end

    counseling
  end
end
