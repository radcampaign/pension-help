class SiteController < ApplicationController
  
  def show_page
    url = params[:url].to_s
    @content = Content.find_by_url(url)
    if @content.nil?
      redirect_to '/404.html'
      return
    end
  end
  
  def exit
    @dest_url = params[:dest]
  end
  
end
