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
    if params[:employer_type]
      # we're coming back from the employer descriptions screen
      @counseling = update_counseling
      @next_question_2 = CAQuestion.get_next(@counseling, 'EMP_TYPE')
    else
      @counseling = session[:counseling] = Counseling.new  # start fresh
    end
  end

  # show question after employer type selection
  def show_second_question
    @counseling = update_counseling
    case @counseling.employer_type_id
        when 1..8: # valid responses
          @next_question = CAQuestion.get_next(@counseling, 'EMP_TYPE')
          render :update do |page| 
            if @next_question
              page.replace_html 'q2', :partial => 'next_question', :locals => {'question' => @next_question, 'selected_value' => nil}
              page.replace_html 'q3', '' 
              page.replace_html 'q4', '' 
              page.visual_effect :highlight, 'q2' 
            else
              # no question found - clear page for now
              # we should reach this once we define all the questions
              page.replace_html 'q2', ''
              page.replace_html 'q3', '' 
              page.replace_html 'q4', '' 
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

    @next_question = CAQuestion.get_next(@counseling, 'STATE')
    render :update do |page| 
      if @next_question
        page.replace_html 'q4', :partial => 'next_question', :locals => {'question' => @next_question, 'selected_value' => nil}
        page.visual_effect :highlight, 'q4'
      end
    end
  end
  
  def step_2 #zip, AoA states, plan questions
    @counseling = update_counseling
    @matching_agencies = @counseling.matching_agencies
    @states = CounselAssistance.states
  end
  
  def step_3 #employment dates, pension-earner, divorce questions
    @counseling = update_counseling
    # skip this question, unless we have a military/federal/private employer type
    redirect_to :action => :step_4 and return unless [1,4,5].include?(@counseling.employer_type_id)
    @options = CounselAssistance.pension_earner_choices
  end
  
  def step_4
    @counseling = update_counseling
    if @counseling.matching_agencies.collect{|a| a.restriction}.compact.empty?
      # no age or income restrctions
      redirect_to :action => :results and return
    else
      render :template => 'help/still_looking' 
    end
    
  end
  
  def results
    @counseling = update_counseling
    @counseling.matching_agencies.each{|a| a.plans.delete_if {|p| p.id != @counseling.selected_plan.id && a.agency_category_id==3}} if @counseling.selected_plan
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
    c = update_counseling #get counseling object from session
    employees = c.matching_agencies.collect{|a| a.plans}.flatten.collect{|p| p.employee_list}.compact.flatten.in_groups_of(2)
    render :partial => 'employee_list', :layout => false, :locals => {'employees' => employees}
  end

  def update_counseling 
    c = session[:counseling] ||= Counseling.new
    c.attributes = params[:counseling]
    c.selected_plan = Plan.find(params[:selected_plan_id]) if !params[:selected_plan_id].blank? && !params[:selected_plan_id].eql?("IDK")
    c.selected_plan = Plan.find(params[:selected_plan_override]) if !params[:selected_plan_override].blank?
    c.employment_start = Date.new (params[:employment_start_year].to_i,1,1) if params[:employment_start_year] && params[:employment_start_year].to_i > EARLIEST_EMPLOYMENT_YEAR && params[:employment_start_year].to_i < LATEST_EMPLOYMENT_YEAR
    c.employment_end = Date.new (params[:employment_end_year].to_i,1,1) if params[:employment_end_year] && params[:employment_end_year].to_i > EARLIEST_EMPLOYMENT_YEAR && params[:employment_end_year].to_i < LATEST_EMPLOYMENT_YEAR
    # c.employer_type = EmployerType.find(params[:employer_type]) if params[:employer_type]
    # c.work_state = State.find(params[:state]) if params[:state]
    # c.county = County.find(params[:county]) if params[:county]
    # c.city = City.find(params[:city]) if params[:city]
    c
  end
  
end
