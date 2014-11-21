class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  http_basic_authenticate_with name: "pha", password: "ph2012a", if: :http_authentication_required , only: [:new]

  force_ssl :if => :ssl_configured?

  include ExceptionNotification

  def ssl_configured?
    !Rails.env.development?
  end

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

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:login, :email, :password, :password_confirmation, :remember_me) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :email, :password, :remember_me) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:email, :password, :password_confirmation, :current_password) }
  end

  def http_authentication_required
    Rails.env === "staging" && is_a?(::DeviseController)
  end

  def after_sign_in_path_for(resource)

    if resource.is_admin?
      '/admin/menu'
    else
     '/'
    end

  end

end
