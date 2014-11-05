class Admin::MenuController < ApplicationController
  before_filter :authenticate_user!, :authorized?

  def authorized?
    current_user.is_admin?
  end

  def index
    render :template => 'admin/menu/index'
  end
  
end
