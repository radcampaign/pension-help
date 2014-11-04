require "email"
require 'yaml'

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
      @counseling = Counseling.new
    end
    update_session
  end

  def step_2 #zip, AoA states, plan questions
    @counseling = update_counseling(counseling_params)
    @previous_to = "/help/counseling"

    if !@counseling.valid?
      @options = CounselAssistance.employer_types
      update_session
      render :action => "counseling"

    else
      @counseling.step = 1
      @states = CounselAssistance.states
      @ask_aoa = [EMP_TYPE[:company], EMP_TYPE[:railroad], EMP_TYPE[:religious],
                  EMP_TYPE[:federal], EMP_TYPE[:military], EMP_TYPE[:unknown]].include?(@counseling.employer_type_id)
      update_session
    end
  end


  def show_second_question
    @counseling = update_counseling(counseling_params)
    @counseling.step = 1

    case @counseling.employer_type_id
      when 1..10
        @next_question = CAQuestion.get_next(@counseling, "EMP_TYPE")

        if @next_question
          @next_question.options = @next_question.options.delete_if { |opt|
            ["AA", "AE", "AP"].include?(opt[1])
          }
        end
        update_session
        render :action => "show_second_question.rjs"
      else
        update_session
        render :update do |page|
          page.redirect_to(:controller => 'help', :action => 'counseling')
        end
    end
  end

  # Remote function - Displays 3nd pulldown based on info submitted from 2nd pulldown
  def show_third_question
    @counseling = update_counseling(counseling_params)
    @counseling.step = 1
    @next_question = CAQuestion.get_next(@counseling, 'THIRD_QUESTION')
    update_session
    render :update do |page|
      if @next_question
        @states = CounselAssistance.states if @next_question.state
        page.replace_html 'q3', :partial => 'next_question', :locals => {:question => @next_question, :selected_value => nil}
        page.visual_effect :highlight, 'q3'
        page.replace_html 'q4', ''
      end
    end
  end

  # Remote function - Displays 4th pulldown based on info submitted from 3rd pulldown
  def show_fourth_question
    @counseling = update_counseling(counseling_params)
    @counseling.step = 1
    if @counseling[:federal_plan_id] == 5 # 'I don't know'
      # Don’t Know Federal Plan Loop
      render :update do |page|
        page.redirect_to(:controller => 'help', :action => 'federal_plan_descriptions')
      end
      update_session
      return
    end

    @next_question = CAQuestion.get_next(@counseling, 'FOURTH_QUESTION')
    update_session
    render :update do |page|
      if @next_question
        page.replace_html 'q4', :partial => 'next_question', :locals => {:question => @next_question, :selected_value => nil}
        page.visual_effect :highlight, 'q4'
      else
        page.replace_html 'q4', nil
      end
    end
  end

  def show_fifth_question
    @counseling = update_counseling(counseling_params)
    update_session
    render :nothing => true
  end

  def show_available_plans
    @counseling = update_counseling(counseling_params)
    @counseling.step = 1
    @matching_plans = @counseling.matching_plans.sort { |a, b| a.name <=> b.name } rescue []
    if @matching_plans.blank?
      update_session
      render :update do |page|
        page.replace_html "q5", :partial => "other_plans"
        page.visual_effect :highlight, "q5"
      end
    else
      @show_option_other = [EMP_TYPE[:county], EMP_TYPE[:city]].include?(@counseling.employer_type_id)
      puts @show_option_other
      update_session
      render :update do |page|
        page.replace_html "q5", :partial => "available_plans"
        page.visual_effect :highlight, "q5"
      end
    end
  end


  # ajax call to check if zipcode is in aoa coverage area
  def check_aoa_zip
    @counseling = update_counseling(counseling_params)

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
      @show_aoa_expansion = false
    elsif @counseling.aoa_coverage.empty? && @ask_aoa &&
        (@counseling.hq_state_abbrev.blank? || @counseling.pension_state_abbrev.blank? || @counseling.work_state_abbrev.blank?)
      @aoa_states = @counseling.aoa_covered_states
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
      @show_aoa_expansion = false
      update_session
      redirect_to(:action => :step_3) and return
    end

    @previous_to = "/help/step_2"
    render :action => :step_2
    update_session
  end

  def step_3
    @counseling = current_counseling
    if @counseling.employer_type_id == EMP_TYPE[:military]
      @options = CounselAssistance.pension_earner_choices
      update_session
    else
      update_session
      redirect_to(:action => :step_5) and return
    end
  end

  def process_step_3
    @counseling = update_counseling(counseling_params)
    @counseling.step = 3

    if @counseling.valid?
      update_session
      redirect_to(:action => :step_5)
    else
      @options = CounselAssistance.pension_earner_choices
      update_session
      render :template => 'help/step_3'
    end
  end

  def step_4
    @counseling = current_counseling

    @age_restrictions = @counseling.age_restrictions?
    @income_restrictions = @counseling.income_restrictions?

    if @counseling.aoa_coverage.empty? and (@age_restrictions || @income_restrictions)
      update_session
      render :template => "help/step_4"
    else
      update_session
      redirect_to(:action => :step_5)
    end
  end

  def process_step_4
    @counseling = update_counseling(counseling_params)
    @counseling.step = 4
    if @counseling.valid?
      update_session
      redirect_to(:action => :step_5)
    else
      @age_restrictions = @counseling.age_restrictions? # put this in an instance variable so we don't have to call it again from the view
      @income_restrictions = @counseling.income_restrictions? # put this in an instance variable so we don't have to call it again from the view
      update_session
      render :template => 'help/step_4'
    end

  end

  def step_5
    @counseling = current_counseling
    if (@counseling.show_step5?)
      update_session
      render :template => 'help/step_5'
    else
      update_session
      redirect_to :action => :results
    end
  end

  def process_step_5
    @counseling = update_counseling(counseling_params)
    @counseling.step = 5
    update_session
    redirect_to :action => :results
  end

  def last_step
    get_previous_to_from_step
    @counseling = update_counseling({})
    @counseling.step = 10
    update_session
  end

  def process_last_step
    @counseling = update_counseling(counseling_params)
    if @counseling.valid?
      update_session
      redirect_to :action => :results
      @counseling.step = 11
    else
      update_session
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
      @results.each { |a| a.plans.delete_if { |p| p.id != @counseling.selected_plan_id.to_i &&
          a.agency_category_id==3 } }
    end
    if [EMP_TYPE[:county], EMP_TYPE[:city]].include?(@counseling.employer_type_id) &&
        @counseling.selected_plan_id.nil?
      @ask_user_for_email = true
    end

    @results
  end

  def email
    if !params[:email].blank?
      unless params[:email] =~ EMAIL_REGEX
        update_session
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

        update_session
        render :update do |page|
          page.hide "send-results-pending"
          page.replace_html "resultsEmailResponse", "E-mail has been sent."
          page.visual_effect :highlight, "resultsEmailResponse"
        end
      end
    else
      update_session
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
    @counseling = update_counseling(counseling_params)
    counties = State.find(params[:counseling][:work_state_abbrev]).counties rescue []

    puts params[:counseling][:work_state_abbrev]
    update_session
    render :update do |page|
      page.replace_html "counties", :partial => "county_selector",
                        :locals => {
                            options: counties.collect { |c| [c.name, c.id] }.
                                sort { |one, two| (one[0] == "I don't know" || two[0] == "I don't know") ? -1 : one[0] <=> two[0] },
                            cities: params[:local]}
      page.visual_effect :highlight, 'county_container'
    end
  end

  def get_localities
    @counseling = update_counseling(counseling_params)

    localities = County.find(params[:counseling][:county_id]).cities rescue []
    update_session
    render :update do |page|
      page.replace_html "localities", :partial => "city_selector",
                        :locals => {
                            options: localities.collect { |c| [c.name, c.id] }.
                                sort { |one, two| (one[0] == "I don't know" || two[0] == "I don't know") ? -1 : one[0] <=> two[0] },
                            cities: "false"}
      page.visual_effect :highlight, 'city_container'
    end
  end

  def get_after_plan_selection_questions
    @counseling = current_counseling
    employees = @counseling.employee_list
    update_session
    if params[:plan] == "IDK"
      if @counseling.employer_type_id == 6 # State agency or office
        render :update do |page|
          page.replace_html 'question_container', :partial => 'employee_list', :layout => false, :locals => {:employees => employees}
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
      update_session
      redirect_to("#{params[:previous_to]}?previous") and return
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
      update_session
      redirect_to(:action => 'last_step') and return
    end
  end

  def show_content(url)
    @content = Content.find_by_url(url)
    render 'site/show_page'
  end

  def hide_email_button
    @hide_email_button = true
  end

  def update_session
    puts "------------>"
    puts "Storing"
    serialized_counseling= @counseling.to_json(methods: [
        :monthly_income_tmp,
        :yearly_income_tmp,
        :step,
        :non_us_resident,
        :income_unanswered,
        :number_in_household_unanswered
    ])
    puts serialized_counseling
    session[:counseling] = serialized_counseling
  end

  def current_counseling
    unless @counseling
      # yaml doesn't load rails classes in production so we just reference it before reloading
      # see http://alisdair.mcdiarmid.org/2013/02/02/fixing-rails-auto-loading-for-serialized-objects.html
      Counseling.class
      @counseling = session[:counseling] ? Counseling.new(ActiveSupport::JSON.decode(session[:counseling])) : Counseling.new
      puts "<------------"
      puts "Loaded"
      puts @counseling.to_json(methods: [
          :monthly_income_tmp,
          :yearly_income_tmp,
          :step,
          :non_us_resident,
          :income_unanswered,
          :number_in_household_unanswered
      ])
    end
    @counseling
  end


  EARLIEST_EMPLOYMENT_YEAR = 1880
  LATEST_EMPLOYMENT_YEAR = 2025

  def update_counseling(data)
    data[:counseling] ||= {}
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


  def counseling_params
    params.permit(counseling: [
        :zipcode,
        :employment_start,
        :employment_end,
        :is_divorce_related,
        :is_survivorship_related,
        :work_state_abbrev,
        :hq_state_abbrev,
        :pension_state_abbrev,
        :is_over_60,
        :monthly_income,
        :number_in_household,
        :employer_type_id,
        :federal_plan_id,
        :military_service_id,
        :military_branch_id,
        :military_employer_id,
        :pension_earner_id,
        :state_abbrev,
        :county_id,
        :city_id,
        :created_at,
        :is_afscme_member,
        :selected_plan_id,
        :currently_employed,
        :plan_name,
        :agency_name,
        :job_function,
        :feedback_email,
        :lost_plan,
        :behalf,
        :behalf_other,
        :gender,
        :marital_status,
        :age,
        :ethnicity,
        :monthly_income_tmp,
        :yearly_income_tmp,
        :step,
        :non_us_resident,
        :income_unanswered,
        :number_in_household_unanswered]
    )
  end

end
