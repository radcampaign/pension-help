class PasswordsController < ApplicationController
  before_filter :login_required, :except => [:create, :new, :edit, :update]

  filter_parameter_logging :old_password, :password, :password_confirmation

  
  def index
    
  end
  
  def show
    
  end
  
  def new

  end

  def create
    respond_to do |format|
      pass = params[:password]
      if user = User.find_by_email_and_login(pass[:email], pass[:login])
        @new_password = random_password
        user.password = user.password_confirmation = @new_password
        user.is_random_pass = true
        user.save_without_validation
        UserMailer.deliver_new_password(user, @new_password)
        
        format.html {
          flash[:notice] = "We sent a new password to #{pass[:email]}"
          redirect_to :controller=> :account, :action=>:login
        }
      else
        flash[:notice] =  "We can't find that account.  Try again."
        format.html { render :action => "new" }
      end
    end
  end

  def edit
    @user = User.find_by_id(params[:id])
  end

  def update
    @user = User.find_by_id(params[:id])
    @user.attributes = params[:user]
    @user.is_random_pass = false
    respond_to do |format|
      if @user.save
        flash[:notice] = "Password has been updated."
        format.html {  redirect_to :controller=>:account, :action=>:login }
      else
        format.html { render :action => 'edit' }
      end
    end
  end
  
  protected
  
  def random_password( len = 20 )
    chars = (("a".."z").to_a + ("1".."9").to_a )- %w(i o 0 1 l 0)
    newpass = Array.new(len, '').collect{chars[rand(chars.size)]}.join
  end
  
end
