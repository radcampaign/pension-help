# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  #include ExceptionNotifiable
  
  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_pha_session_id'
  layout 'default'
  
  def get_counties_for_states
    @states = params[:states].split(',').collect{|s| State.find_by_abbrev(s)}
    @county_ids = params[:county_ids]
    render :partial => '/shared/counties', :locals => {:states => @states}, :layout => false
  end  
  
  def get_cities_for_counties
    @counties = params[:counties].split(',').collect{|c| County.find(c)} if (params[:counties] != 'null')
    @city_ids = params[:city_ids]
    render :partial => '/shared/cities', :locals => {:counties => @counties}, :layout => false
  end
  
  def get_zips_for_counties
    @counties = params[:counties].split(',').collect{|c| County.find(c)} if (params[:counties]!='null')
    @zip_ids = params[:zip_ids]
    render :partial => '/shared/zips', :locals => {:counties => @counties}, :layout => false
  end

end
