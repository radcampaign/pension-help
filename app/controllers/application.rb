# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  include ExceptionNotifiable
  
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
    render :partial => '/shared/counties', :locals => {:states => @states}, :layout => false
  end  
  
  def get_cities_for_counties
    begin
      @counties = params[:counties].split(',').collect{|c| County.find(c)} if (params[:counties] != 'null')
    rescue ActiveRecord::RecordNotFound
      nil
    end
    @city_ids = params[:city_ids]
    render :partial => '/shared/cities', :locals => {:counties => @counties}, :layout => false
  end
  
  def get_zips_for_counties
    begin
      @counties = params[:counties].split(',').collect{|c| County.find(c)} if (params[:counties]!='null')
    rescue ActiveRecord::RecordNotFound
      nil
    end
    @zip_ids = params[:zip_ids]
    render :partial => '/shared/zips', :locals => {:counties => @counties}, :layout => false
  end

  def rescue_action_in_public(exception)
    case exception
      when ActiveRecord::RecordNotFound,ActionController::UnknownAction 
        render "site/404", :status => "404"
      else
        @message = exception
        render "site/505", :status => "500"
    end
  end

  def local_request?
    return false
  end

end
