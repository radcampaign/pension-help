class HelpController < ApplicationController
  def index
    @content = Content.find_by_url('help')
    render :template => "site/show_page.rhtml"
  end
  
  def counseling
    @content = Content.find_by_url('help/counseling')
    render :template => "site/show_page.rhtml"
  end
end
