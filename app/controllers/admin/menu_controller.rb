class Admin::MenuController < ApplicationController
  before_filter :login_required

  def authorized?
    current_user.is_admin?
  end

  def index
    render :template => 'admin/menu/index', :layout => 'admin'
  end
  
end
