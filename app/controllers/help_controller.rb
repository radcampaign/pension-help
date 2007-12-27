class HelpController < ApplicationController
  
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
    if params[:id] == "IDK_GOV_EMP"
      # Don’t Know Govt. Employer Type Loop
      render :update do |page| 
        page.redirect_to(:controller => 'help', :action => 'government_descriptions')
      end
      return
    elsif params[:id] == "IDK_PRV_EMP"
      # Don’t Know Private Employer Type Loop
      render :update do |page| 
        page.redirect_to(:controller => 'help', :action => 'private_descriptions')
      end
      return
    end
    
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
  
  def step_2
    @counseling = update_counseling
  end
  
  def step_3
    @options = CounselAssistance.pension_earner_choices
  end
  
  def expand
    @states = CounselAssistance.states
  end
  
  def results
    # Simply showing the user what they previously submitted 
    @requested_plan = CounselAssistance.find_plan(session[:requested_plan])
    render "help/results_state" if (session[:requested_plan] == "ST_PLAN")
  end
  
  # Used for populating state, county and local pulldowns 
  
  def get_counties
    counties = State.find(params[:state]).counties
    render :update do |page| 
        page.replace_html 'counties', :partial => 'county_selector', :locals => {'options' => State.find(params[:state]).counties.collect{|c| [c.name, c.id]}.sort, 'cities' => params[:local]}
        page.visual_effect :highlight, 'county_container'
    end
  end
  
  def get_localities
    localities = County.find(params[:county]).cities
    render :update do |page| 
        page.replace_html 'localities', :partial => 'city_selector', :locals => {'options' => County.find(params[:county]).cities.collect{|c| [c.name, c.id]}.sort, 'cities' => 'false'}
        page.visual_effect :highlight, 'city_container'
    end
  end
  
  def update_counseling 
    c = session[:counseling] ||= Counseling.new
    c.employer_type = EmployerType.find(params[:employer_type]) if params[:employer_type]
    c.state = State.find(params[:state]) if params[:state]
    c.county = County.find(params[:county]) if params[:county]
    c.city = City.find(params[:city]) if params[:city]
    c
  end
  
end
