class PalsController < ApplicationController
  def index
    @content = Content.find_by_url('pals')
    render :template => "site/show_page.rhtml"
  end
  
  def service_partners
    @content = Content.find_by_url('pals/service_partners')
    render :template => "site/show_page.rhtml"
  end
  
  def funding_partners
    @content = Content.find_by_url('pals/funding_partners')
    render :template => "site/show_page.rhtml"
  end
  
  def founding_partners
    @content = Content.find_by_url('pals/founding_partners')
    render :template => "site/show_page.rhtml"
  end
  
  def how_to_help
    @content = Content.find_by_url('pals/how_to_help')
    render :template => "site/show_page.rhtml"
  end
end
