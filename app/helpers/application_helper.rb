# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def scroll_arrow
    "<script type=\"text/javascript\" language=\"javascript\">
    	$('scrollDownIcon').show();
    </script>"
  end
  
  # Create select tag that submits an Ajax call onchange
  def remote_select(object,method,options,controller,action,selected_value=nil)
    option_tags = "<option value=''></option>"
    options.each do |option|
      if selected_value.to_s == option[1].to_s
        option_tags << "<option value='#{option[1]}' selected='selected'>#{option[0]}</option>"
      else
        option_tags << "<option value='#{option[1]}'>#{option[0]}</option>"
      end
    end
    "<select name=\"#{object}[#{method}]\" id=\"#{object}[#{method}]\" onchange=\"new Ajax.Request('/#{controller}/#{action}', 
    {asynchronous:false, evalScripts:true, parameters:'#{object}[#{method}]='+escape(value), onComplete:validateStep()})\">" + option_tags + "</select>"
  end

  def pal_checked?(partner, item)
    levels = partner.pal_participation_levels
    levels.collect(&:name).include?(item.name) || (levels.map(&:name).blank? && partner.wants_pal )
  end

  def npln_checked?(partner, item)
    levels = partner.npln_participation_levels
    levels.collect(&:name).include?(item.name) || (levels.map(&:name).blank? && partner.wants_npln )
  end

end
