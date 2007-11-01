class SearchController < ApplicationController
  def index
    @scroll = true
    @content = Content.find_by_url('search')
    render :template => "site/show_page.rhtml"
  end
  
  def method_missing(method, *args)
    @content = Content.find_by_url("search/#{method}")
    redirect_to '/404.html' and return unless @content
    render :template => "site/show_page.rhtml"
  end
end
