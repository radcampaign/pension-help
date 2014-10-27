class PalsController < ApplicationController
  def index
    @content = Content.find_by_url('pals')
    render :template => "site/show_page.rhtml"
  end

  def method_missing(method, *args)
    @content = Content.find_by_url("pals/#{method}")
    redirect_to '/404.html' and return unless @content
    render :template => "site/show_page.rhtml"
  end
  
end
