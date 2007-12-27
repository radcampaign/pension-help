# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def scroll_arrow
    "<script type=\"text/javascript\" language=\"javascript\">
    	$('scrollDownIcon').show();
    </script>"
  end
  
  # Create select tag that submits an Ajax call onchange
  def remote_select(name,options,controller,action,selected_value=nil)
    option_tags = "<option value=''></option>"
    options.each do |option|
      if selected_value.to_s == option[1].to_s
        option_tags << "<option value='#{option[1]}' selected='selected'>#{option[0]}</option>"
      else
        option_tags << "<option value='#{option[1]}'>#{option[0]}</option>"
      end
    end
    "<select name=\"#{name}\" onchange=\"new Ajax.Request('/#{controller}/#{action}', 
    {asynchronous:true, evalScripts:true, parameters:'#{name}='+escape(value)})\">" + option_tags + "</select>"
  end
  
end
