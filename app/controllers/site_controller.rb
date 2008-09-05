class SiteController < ApplicationController
  
  def show_page
    url = params[:url].to_s
    @content = Content.find_by_url_and_is_active(url, true)
    if @content.nil?
      render :template => 'site/404', :status => 404
      return
    end
  end
  
  def exit
    @dest_url = CGI::unescape params[:dest]
    @dest_url = "http://" + @dest_url unless @dest_url.include? "http://" or @dest_url.include? "https://"
  end
  
end
