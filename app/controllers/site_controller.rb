class SiteController < ApplicationController
  
  def show_page
    url = params[:url].to_s
    puts "-----------#{url}"
    @content = Content.find_by_url_and_is_active(url, true)
    puts "-----------#{@content}"
    if @content.nil?
      render :template => 'site/404', :status => 404
      return
    end
  end
  
  def exit
    require 'socket'
    @dest_url = params[:dest] ? CGI::unescape(params[:dest]) : self.request.host+":"+self.request.port.to_s
    @dest_url = "http://" + @dest_url unless @dest_url.include? "http://" or @dest_url.include? "https://"
  end
  
end
