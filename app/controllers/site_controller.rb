class SiteController < ApplicationController
  
  def show_page
    url = params[:url].to_s
    @content = Content.find_by_url_and_is_active(url, true)
    if @content.nil?
      redirect_to :action => :not_found
      return
    end
  end
  
  def exit
    @dest_url = CGI::unescape params[:dest]
    @dest_url = "http://" + @dest_url unless @dest_url.include? "http://" or @dest_url.include? "https://"
  end
  
  def not_found
    render 'site/404'
  end
end
