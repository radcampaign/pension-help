# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def scroll_arrow
    "<script type=\"text/javascript\" language=\"javascript\">
    	$('scrollDownIcon').show();
    </script>"
  end
  
  def offiste_link(title,url)
    url = "http://" + url unless url.include? "http://" or url.include? "https://"
    "<a href=\"/site/exit?dest=#{url}\" class=\"offsite\">
      #{title}
    </a>"
  end
  
end
