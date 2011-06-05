class HelpController < ApplicationController
  before_filter :check_aoa_zip, :only => [:step3]

  EARLIEST_EMPLOYMENT_YEAR = 1880
  LATEST_EMPLOYMENT_YEAR = 2025
  DEFAULT_ZIP = '20036' # used for non-US residents

  def index
    @content = Content.find_by_url('help')
    render :template => "site/show_page.rhtml"
  end

  def resources
    @content = Content.find_by_url('help/resources')
    render :template => "site/show_page.rhtml"
  end

  def counseling
    @counseling = session[:counseling] = Counseling.new #start with a fresh object
    @options = CounselAssistance.employer_types
  end

  def employer_descriptions
    @counseling = update_counseling
  end

  def update_employer_type
    @counseling = update_counseling
    @options = CounselAssistance.employer_types
    render :action => :counseling
  end

  def process_counseling
    @counseling = update_counseling
    @counseling.step = 1
    if @counseling.valid?
      redirect_to :action => :step_2
    else
      @next_question_2 = CAQuestion.get_next(@counseling, 'EMP_TYPE')
      @options = CounselAssistance.employer_types
      render :template => 'help/counseling'
    end
  end

  # show question after employer type selection
  def show_second_question
    @counseling = update_counseling
    @counseling.step = 1
    case @counseling.employer_type_id
      when 1..10: # valid responses
        @next_question = CAQuestion.get_next(@counseling, 'EMP_TYPE')
        (@next_question.options = @next_question.options.delete_if {|opt| opt[1] == "AA" || opt[1] == "AE" or opt[1] == "AP"}) if @next_question # remove armed forces
        render :update do |page|
          if @next_question
            page.replace_html 'q2', :partial => 'next_question', :locals => {'question' => @next_question, 'selected_value' => @counseling[@next_question.method]}
            page.replace_html 'q3', ''
            page.replace_html 'q4', ''
            page.replace_html 'q5', ''
            page.visual_effect :highlight, 'q2'
          else
            # no question found - clear page for now
            # we should reach this once we define all the questions
            page.replace_html 'q2', ''
            page.replace_html 'q3', ''
            page.replace_html 'q4', ''
            page.replace_html 'q5', ''
          end
        end
        return
      else # start over
        render :update do |page|
          page.redirect_to(:controller => 'help', :action => 'counseling')
        end
        return
    end #case
  end

  # Remote function - Displays 3nd pulldown based on info submitted from 2nd pulldown
  def show_third_question
    @counseling = update_counseling
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
    @counseling = update_counseling
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
        page << 'validateStep();'
      end
    end
  end

  def show_fifth_question
    @counseling = update_counseling
    render :nothing => true
  end

  def show_available_plans
    @counseling = update_counseling
    @counseling.step = 1
    @matching_plans = @counseling.matching_plans.sort{|a, b| a.name <=> b.name} # find plans for state/county/local
    if @matching_plans.blank?
      render :update do |page|
        page.replace_html 'q5', :partial => 'other_plans'
        page.visual_effect :highlight, 'q5'
      end
    else
      @show_option_other = [EMP_TYPE[:county], EMP_TYPE[:city]].include?(@counseling.employer_type_id)
      render :update do |page|
        page.replace_html 'q5', :partial => 'available_plans'
        page.visual_effect :highlight, 'q5'
      end
    end
  end

  def step_2 #zip, AoA states, plan questions
    @zip_found = true
    @counseling = update_counseling
    @counseling.step = 2
    @states = CounselAssistance.states
    @ask_aoa = [EMP_TYPE[:company], EMP_TYPE[:railroad], EMP_TYPE[:religious],
                EMP_TYPE[:federal], EMP_TYPE[:military], EMP_TYPE[:unknown]].include?(@counseling.employer_type_id)
  end

  # ajax call to check if zipcode is in aoa coverage area
  def check_aoa_zip
    @counseling = update_counseling
    @counseling.zipcode = params[:zip] if !params[:zip].blank?
    #@counseling.step = 3
    @states = CounselAssistance.states
    @ask_aoa = [EMP_TYPE[:company], EMP_TYPE[:railroad], EMP_TYPE[:religious],
                EMP_TYPE[:federal], EMP_TYPE[:military], EMP_TYPE[:unknown],
                EMP_TYPE[:farm_credit] ].include?(@counseling.employer_type_id)
    @counseling.zipcode = DEFAULT_ZIP if @counseling.non_us_resident == '1'
    if !@counseling.valid? # bad zip code entered
      @zip_found = false
      @show_aoa_expansion = false
    elsif @counseling.aoa_coverage.empty? and @ask_aoa and
         (@counseling.hq_state_abbrev.blank? or @counseling.pension_state_abbrev.blank? or @counseling.work_state_abbrev.blank?)
      # good zip, but no AoA coverage - ask more questions
      @counseling.step = '2a'
      @aoa_states = @counseling.aoa_covered_states
      @zip_found = true
      @show_aoa_expansion = true
    else # good zip with AoA coverage, or good zip but no need to ask AoA questions
      if @counseling.aoa_coverage.empty?
        # clear out extra state dropdowns, as we won't consider them in this case
        @counseling.hq_state_abbrev = @counseling.pension_state_abbrev = nil
        # but preserve work_state if user is state/county/local employee
        @counseling.work_state_abbrev = nil unless [EMP_TYPE[:state],
                                                    EMP_TYPE[:county],
                                                    EMP_TYPE[:city] ].include?(@counseling.employer_type_id)
      end
      @zip_found = true
      @show_aoa_expansion = false
      redirect_to :action => :step_3
      return
    end
    render :action => :step_2
  end

  def step_3 #employment dates, pension-earner, divorce questions
    @counseling = find_counseling
    @options = CounselAssistance.pension_earner_choices
  end

  def process_step_3
    @counseling = update_counseling

    if @counseling.valid?
      redirect_to :action => :step_4
    else
      @options = CounselAssistance.pension_earner_choices
      render :template => 'help/step_3'
    end
  end

  def step_4
    @counseling = find_counseling

    @age_restrictions = @counseling.age_restrictions? # put this in an instance variable so we don't have to call it again from the view
    @income_restrictions = @counseling.income_restrictions? # put this in an instance variable so we don't have to call it again from the view
    # show step_4 only if we need to
    if @counseling.aoa_coverage.empty? and (@age_restrictions || @income_restrictions)
      render :template => 'help/step_4'
    else
      redirect_to :action => :step_5
    end
  end

  def process_step_4
    @counseling = update_counseling
    @counseling.step = 4
    if @counseling.valid?
      redirect_to :action => :step_5
    else
      @age_restrictions = @counseling.age_restrictions? # put this in an instance variable so we don't have to call it again from the view
      @income_restrictions = @counseling.income_restrictions? # put this in an instance variable so we don't have to call it again from the view
      render :template => 'help/step_4'
    end
  end

  def step_5
    @counseling = find_counseling
    if (@counseling.show_step5?)
      render :template => 'help/step_5'
    else
      redirect_to :action => :results
    end
  end

  def process_step_5
    @counseling = update_counseling
    @counseling.step = 5
    redirect_to :action => :results
  end

  def results
    @counseling = find_counseling
    @zip_import = ZipImport.find_by_zipcode(@counseling.zipcode)
    @results = @counseling.matching_agencies
    begin
      @currently_employed_text = Content.find_by_url('currently_employed_text').content
    rescue ActiveRecord::RecordNotFound
      nil # continue on if we don't find anything
    end
    @lost_plan_resources = Content.find_by_url('lost_plan_resources').content rescue nil if @counseling.show_lost_plan_resources
    @counseling.save
    if @counseling.selected_plan_id
      @results.each{|a| a.plans.delete_if {|p| p.id != @counseling.selected_plan_id.to_i &&
              a.agency_category_id==3}}
    end
    if [EMP_TYPE[:county], EMP_TYPE[:city] ].include?(@counseling.employer_type_id) &&
      @counseling.selected_plan_id.nil?
        # we don't have a plan on file.  notify PRC and ask user if they want to be notified
        Mailer.deliver_unavailable_plan(@counseling)
        @ask_user_for_email = true
    end

    @results
  end

  def submit_email_address
    counseling = Counseling.find(params[:counseling][:id])
    if counseling
      counseling.feedback_email = params[:counseling][:feedback_email]
      counseling.save
      Mailer.deliver_unavailable_plan_feedback(counseling)
      render :update do |page|
        page << "$('counseling_feedback_email').writeAttribute('disabled', true)"
        page << "$('feedbackEmailSubmit').writeAttribute('disabled', true)"
        page.replace_html 'feedbackEmailResponse', :partial => 'feedback_email_accepted'
        page.visual_effect :highlight, 'feedbackEmailResponse'
      end
    end
  end

  # Used for populating state, county and local pulldowns
  def get_counties
    counties = State.find(params[:counseling][:work_state_abbrev]).counties
    render :update do |page|
      page.replace_html 'counties', :partial => 'county_selector', :locals => {'options' => counties.collect{|c| [c.name, c.id]}.sort, 'cities' => params[:local]}
      page.visual_effect :highlight, 'county_container'
    end
  end

  def get_localities
    localities = County.find(params[:counseling][:county_id]).cities
    render :update do |page|
      page.replace_html 'localities', :partial => 'city_selector', :locals => {'options' => localities.collect{|c| [c.name, c.id]}.sort, 'cities' => 'false'}
      page.visual_effect :highlight, 'city_container'
    end
  end

  def get_after_plan_selection_questions

    @counseling = update_counseling
    if params[:plan]=="IDK"
      c = update_counseling #get counseling object from session
      employees = c.employee_list

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

  def update_counseling
    c = find_counseling
    c.attributes = params[:counseling]
    # if yrly amt is entered, we need to override what's been put into monthly amount by setting the attributes
    c.yearly_income = params[:counseling][:yearly_income] if params[:counseling] and not params[:counseling][:yearly_income].blank?
    # make IDK => 0
    c.selected_plan_id = nil if (c.selected_plan_id=="IDK" or c.selected_plan_id=="OTHER" or c.selected_plan_id==0)
    c.selected_plan_id = c.federal_plan.associated_plan_id if c.federal_plan_id and FederalPlan.find(c.federal_plan_id).associated_plan_id
    logger.debug ("\nc.federal_plan_id is " + c.federal_plan_id.to_s)
    logger.debug ("\nFederalPlan.find(c.federal_plan_id).associated_plan_id is " + FederalPlan.find(c.federal_plan_id).associated_plan_id.to_s) unless c.federal_plan_id.nil?
    c.selected_plan_id = params[:selected_plan_override] if !params[:selected_plan_override].blank?
    # set date here if we have a year, but do validation on year elsewhere so we can redraw the page
    # we'll have to limit the display of the date to the year only
    c.employment_start = Date.new(params[:employment_start_year].to_i, 1, 1) if params[:employment_start_year] && params[:employment_start_year].to_i > EARLIEST_EMPLOYMENT_YEAR && params[:employment_start_year].to_i < LATEST_EMPLOYMENT_YEAR
    c.employment_end = Date.new(params[:employment_end_year].to_i, 1, 1) if params[:employment_end_year] && params[:employment_end_year].to_i > EARLIEST_EMPLOYMENT_YEAR && params[:employment_end_year].to_i < LATEST_EMPLOYMENT_YEAR
    # force currently_employed false if employment ended in a prior year
    c.currently_employed = false if c.currently_employed.nil? and !c.employment_end.nil? and c.employment_end.year < Time.now.year
    # c.employer_type = EmployerType.find(params[:employer_type]) if params[:employer_type]
    # c.work_state = State.find(params[:state]) if params[:state]
    # c.county = County.find(params[:county]) if params[:county]
    # c.city = City.find(params[:city]) if params[:city]
    logger.debug('after update, c is now set to ' + c.inspect )
    c
  end

  def find_counseling
    if session[:counseling]
      c=session[:counseling]
    else
      c=Counseling.new
    end
    c
  end

end
