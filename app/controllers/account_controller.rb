class AccountController < ApplicationController

  include AccountHelper

  # If you want "remember me" functionality, add this before_filter to Application Controller
  #before_filter :login_from_cookie

  # say something nice, you goof!  something sweet.
  def index
    redirect_to(:action => 'login') 
  end

  def login
    return unless request.post?

    tmp_user = User.authenticate(params[:login], params[:password])

    if (tmp_user != :false) && !tmp_user.nil?
      if tmp_user.is_random_pass
        redirect_to edit_password_path(tmp_user)
        return
      end
    end

    self.current_user = User.authenticate(params[:login], params[:password])
    if logged_in?
      if params[:remember_me] == "1"
        self.current_user.remember_me
        cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
      end
      if current_user.is_admin?
        redirect_back_or_default(:controller => '/admin', :action => 'menu')
      elsif current_user.is_network_user?
        redirect_back_or_default(:controller => '/partners', :action => 'edit', :id => current_user.partner)
      end
      flash[:notice] = "Logged in successfully"
    end
  end

  def signup
    @user = User.new(params[:user])
    return unless request.post?
    @user.save!
    self.current_user = @user
    redirect_back_or_default(:controller => '/')
    flash[:notice] = "Thanks for signing up!"
  rescue ActiveRecord::RecordInvalid
    render :action => 'signup'
  end
  
  def logout
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_back_or_default(:controller => '/')
  end
end
