class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  http_basic_authenticate_with name: "pha", password: "ph2012a", if: :http_authentication_required , only: [:new]

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

    if current_user.is_admin?
      '/admin/menu'
    elsif current_user.is_network_user?
     '/partners/edit'
    else
     '/'
    end

  end

end
