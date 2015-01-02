class PalsController < ApplicationController
  def index
    @content = Content.find_by_url('pals')
    render 'site/show_page'
  end

  def method_missing(method, *args)
    @content = Content.find_by_url("pals/#{method}")
    redirect_to '/404.html' and return unless @content
    render 'site/show_page'
  end
  
end
