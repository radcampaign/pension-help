class HelpController < ApplicationController

  EARLIEST_EMPLOYMENT_YEAR = 1880
  LATEST_EMPLOYMENT_YEAR = 2025
  
  def index
    @content = Content.find_by_url('help')
    render :template => "site/show_page.rhtml"
  end
  
  def resources
    @content = Content.find_by_url('help/resources')
    render :template => "site/show_page.rhtml"
  end
  
  def counseling
    @options = CounselAssistance.employer_types
    @counseling.step = 1 unless @counseling.nil?
    if params[:counseling] || params[:redirect]
      # we're coming back from the employer descriptions screen 
      # or we're redirect back here due to a validation error
      @counseling = update_counseling
      @next_question_2 = CAQuestion.get_next(@counseling, 'EMP_TYPE')
    else
      @counseling = session[:counseling] = Counseling.new  # start fresh
    end
  end

  # show question after employer type selection
  def show_second_question
    @counseling = update_counseling
    @counseling.step = 1
    case @counseling.employer_type_id
        when 1..8: # valid responses
          @next_question = CAQuestion.get_next(@counseling, 'EMP_TYPE')
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
        when 9: # don't know 
          render :update do |page| 
            page.redirect_to(:controller => 'help', :action => 'employer_descriptions')
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
    @next_question = CAQuestion.find(params[:id])
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
    
    @next_question = CAQuestion.get_next(@counseling, 'STATE')
    render :update do |page| 
      if @next_question
        page.replace_html 'q4', :partial => 'next_question', :locals => {'question' => @next_question, 'selected_value' => nil}
        page.visual_effect :highlight, 'q4'
      end
    end
  end
  
  def show_available_plans
    @counseling = update_counseling
    @counseling.step = 1
    @matching_agencies = @counseling.matching_agencies # find plans for state/county/local
    render :update do |page|
      page.replace_html 'q5', :partial => 'available_plans'
      page.visual_effect :highlight, 'q5'
    end
  end
  
  def step_2 #zip, AoA states, plan questions
    @counseling = update_counseling
    redirect_to(:action => :counseling, :redirect => true) and return if (!@counseling.valid? and request.post?)
    @counseling.step = 2
    @states = CounselAssistance.states
    @ask_aoa = [1,2,3,4,5,9].include?(@counseling.employer_type_id)
  end
  
  # ajax call to check if zipcode is in aoa coverage area
  def check_aoa_zip
    @counseling = update_counseling
    @counseling.zipcode = params[:zip] if !params[:zip].blank?
    #@counseling.step = 3
    @states = CounselAssistance.states
    @ask_aoa = [1,2,3,4,5,9].include?(@counseling.employer_type_id)
    if !@counseling.valid?                  # bad zip code entered
      @zip_found = false
      @show_aoa_expansion = false
    elsif params['continue.x']              # next button at bottom clicked
      redirect_to :action => :step_3 
      return
    elsif @counseling.aoa_coverage.empty? &&
          @ask_aoa                          # good zip, but no AoA coverage - ask more questions
      @zip_found = true
      @show_aoa_expansion = true
    else
      @zip_found = true
      @show_aoa_expansion = false           # good zip, AoA coverage, prompt user to continue
    end
    render :action => :step_2
  end
  
  def step_3 #employment dates, pension-earner, divorce questions
    @counseling = update_counseling
    if !@counseling.valid? and request.post?
      @states = CounselAssistance.states
      redirect_to :action => :step_2
      return
    end
    @counseling.step = 3
    # skip this question, unless we have a military/federal/private employer type
    redirect_to :action => :step_4 and return unless [1,4,5].include?(@counseling.employer_type_id)
    @options = CounselAssistance.pension_earner_choices
  end
  
  def step_4
    @counseling = update_counseling
    if !@counseling.valid? and request.post?
      @options = CounselAssistance.pension_earner_choices
      redirect_to :action => :step_3
      return
    end
    @counseling.step = 4
    @ask_afscme = [6,7,8].include?(@counseling.employer_type_id)
    @age_restrictions = @counseling.age_restrictions? # put this in an instance variable so we don't have to call it again from the view
    @income_restrictions = @counseling.income_restrictions? # put this in an instance variable so we don't have to call it again from the view
    # show still_looking only if we need to
    if @counseling.aoa_coverage.empty? and (@age_restrictions || @income_restrictions || @ask_afscme)
      render :template => 'help/still_looking' 
    else
      redirect_to :action => :results and return
    end
  end
  
  def results
    @counseling = update_counseling
    @results = @counseling.matching_agencies

    redirect_to :action => :step_4 unless (@counseling.valid? or !request.post?)

    @counseling.save
    if @counseling.selected_plan_id
      @results.each{|a| a.plans.delete_if {|p| p.id != @counseling.selected_plan_id.to_i &&
         a.agency_category_id==3}} 
    end
    @results
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
  
  def get_employee_list
    if params[:plan]=="IDK"
      c = update_counseling #get counseling object from session
      employees_unsorted = c.matching_agencies.collect{|a| a.plans}.flatten.collect{|p| p.employee_list}.compact.flatten.in_groups_of(2)
      employees = employees_unsorted.sort do |a,b|
        # put all employees with 'other' at the end of the list
        if a[0].downcase.include?('other') and !b[0].downcase.include?('other')
          1
        elsif b[0].downcase.include?('other') and !a[0].downcase.include?('other')
          -1
        else
          a[0].downcase <=> b[0].downcase
        end
      end
      render :update do |page|
        page.replace_html 'employee_list_container', :partial => 'employee_list', :layout => false, :locals => {'employees' => employees}
        page.visual_effect :highlight, 'employee_list_container'
      end
    else
      render :update do |page|
        page.replace_html 'employee_list_container', "&nbsp;"
      end
    end
  end

  def update_counseling 
    c = session[:counseling] ||= Counseling.new
    c.attributes = params[:counseling]
    # if yrly amt is entered, we need to override what's been put into monthly amount by setting the attributes
    c.yearly_income = params[:counseling][:yearly_income] if params[:counseling] and not params[:counseling][:yearly_income].blank? 
    # make IDK => 0
    c.selected_plan_id = nil if c.selected_plan_id=="IDK"
    c.selected_plan_id = params[:selected_plan_override] if !params[:selected_plan_override].blank?
    # set date here if we have a year, but do validation on year elsewhere so we can redraw the page
    # we'll have to limit the display of the date to the year only
    c.employment_start = Date.new(params[:employment_start_year].to_i,1,1) if params[:employment_start_year] && params[:employment_start_year].to_i > EARLIEST_EMPLOYMENT_YEAR && params[:employment_start_year].to_i < LATEST_EMPLOYMENT_YEAR
    c.employment_end = Date.new(params[:employment_end_year].to_i,1,1) if params[:employment_end_year] && params[:employment_end_year].to_i > EARLIEST_EMPLOYMENT_YEAR && params[:employment_end_year].to_i < LATEST_EMPLOYMENT_YEAR
    c.employment_end = Date.new(1987,3,31) if c.employment_cutoff=="on"
    c.employment_end = Date.new(1987,4,2) if c.employment_cutoff=="off"
    # c.employer_type = EmployerType.find(params[:employer_type]) if params[:employer_type]
    # c.work_state = State.find(params[:state]) if params[:state]
    # c.county = County.find(params[:county]) if params[:county]
    # c.city = City.find(params[:city]) if params[:city]
    c
  end
  
end
