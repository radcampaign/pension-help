# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  include ExceptionNotifiable
   
  before_filter :check_support_for_cookies 

  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_pha_session_id'
  layout 'default'
  
  def get_counties_for_states
    begin
      @states = params[:states].split(',').collect{|s| State.find_by_abbrev(s)}
    rescue ActiveRecord::RecordNotFound
      nil
    end
    @county_ids = params[:county_ids]
    render :partial => '/shared/counties', :locals => {:states => @states, :id_prefix => params[:id_prefix]}, :layout => false
  end  
  
  def get_cities_for_counties
    begin
      @counties = params[:counties].split(',').collect{|c| County.find(c)} if (params[:counties] != nil)
    rescue ActiveRecord::RecordNotFound
      nil
    end
    @city_ids = params[:city_ids]
    render :partial => '/shared/cities', :locals => {:counties => @counties, :id_prefix => params[:id_prefix]}, :layout => false
  end
  
  def get_zips_for_counties
    begin
      @counties = params[:counties].split(',').collect{|c| County.find(c)} if (params[:counties]!=nil)
    rescue ActiveRecord::RecordNotFound
      nil
    end
    @zip_ids = params[:zip_ids]
    render :partial => '/shared/zips', :locals => {:counties => @counties, :id_prefix => params[:id_prefix]}, :layout => false
  end

  def rescue_action_in_public(exception)
    case exception
      #strange bug, in comparison ActionController::UknownAction is replaced with ActionWebService::Dispatcher::ActionController
      when ActiveRecord::RecordNotFound,::ActionController::UnknownAction 
        render :template => "site/404", :status => "404", :layout => 'default'
      else
        @message = exception
        render :template => "site/505", :status => "500", :layout => 'default'
    end
  end

  def local_request?
    return false
  end

  #Checks if user's browser supports cookies.
  def check_support_for_cookies
    #list of controllers to check for support
    controllers_to_check = %w[help account]

    if (controllers_to_check.include?(controller_name))
      #Checks if there is session_id set in cookie
      if (request.cookies["_pha_session_id"].to_s.blank?)
        #if user enters site for the first time, cookie might not be set,
        #so redirect to self and check again, this time we would know that user
        #has already visitted page
        #http://jameshalberg.com/2006/05/12/requiring-and-testing-cookies/
        if params[:cookies].nil?
          redirect_to :controller => params[:controller],
                :action => params[:action],
                :cookies => 'true'
        else
          redirect_to :controller => :warning, :action => :show, :cookies_disabled => true
        end
      end
    end
  end
end
