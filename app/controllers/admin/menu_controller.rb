class Admin::MenuController < ApplicationController
  
  def index
    render :template => 'admin/menu/index', :layout => 'admin'
  end
  
end
