class HelpController < ApplicationController
  
  def index
    @content = Content.find_by_url('help')
    render :template => "site/show_page.rhtml"
  end
  
  def counseling
    @options = CounselAssistance.employer_types
    if params[:id_2]
      @selected_value_1 = params[:id_2]
      @next_question_2 = CAQuestion.find(params[:id_2])
    end
    if params[:id_3]
      @selected_value_2 = params[:id_3]
      @next_question_3 = CAQuestion.find(params[:id_3])
      @states = CounselAssistance.states if @next_question_3 and @next_question_3.state
    end
    if params[:id_4]
      @selected_value_3 = params[:id_4]
      @next_question_4 = CAQuestion.find(params[:id_4])
    end
    #@content = Content.find_by_url('help/counseling')
    #render :template => "site/show_page.rhtml"
  end
  
  # Remote function - Displays 2nd pulldown based on info submitted from 1st pulldown
  def show_second_question
    if params[:id] == "IDK_EMP"
      # Don’t Know Employer Type Loop
      render :update do |page| 
        page.redirect_to(:controller => 'help', :action => 'employer_descriptions')
      end
      return
    elsif params[:id] == ""
      # Start over
      render :update do |page| 
        page.redirect_to(:controller => 'help', :action => 'counseling')
      end
      return
    end
    
    @next_question = CAQuestion.find(params[:id])
    render :update do |page| 
      if @next_question
        page.replace_html 'q2', :partial => 'next_question', :locals => {'question' => @next_question, 'selected_value' => nil}
        page.replace_html 'q3', '' 
        page.replace_html 'q4', '' 
        page.visual_effect :highlight, 'q2' 
      end
    end
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
    if params[:id] == "IDK_FED_PLAN"
      # Don’t Know Federal Plan Loop 
      render :update do |page| 
        page.redirect_to(:controller => 'help', :action => 'federal_plan_descriptions')
      end
      return
    end
    
    @next_question = CAQuestion.find(params[:id])
    render :update do |page| 
      if @next_question
        page.replace_html 'q4', :partial => 'next_question', :locals => {'question' => @next_question, 'selected_value' => nil}
        page.visual_effect :highlight, 'q4'
      end
    end
  end
  
  def step_2
    session[:requested_plan] = params[:requested_plan]
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
  
  # Used for populating state, county and local pulldowns for demo. Will be removed.
  
  def get_counties
    counties = CounselAssistance.counties
    render :update do |page| 
        page.replace_html 'counties', :partial => 'location_selector', :locals => {'options' => counties, 'more' => params[:local]}
        page.visual_effect :highlight, 'counties'
    end
  end
  
  def get_localities
    localities = CounselAssistance.localities
    render :update do |page| 
        page.replace_html 'localities', :partial => 'location_selector', :locals => {'options' => localities, 'more' => 'false'}
        page.visual_effect :highlight, 'localities'
    end
  end
  
end
