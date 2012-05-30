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

  def current_class(*urls)
    for url in urls do
      return "" if url == 'help' and request.path.include?('resource') # special case as URL help/resources matches twice
      return "active" if  (url == 'home' && params[:controller] == 'site' && params[:url].to_s == '/') || request.path.include?(url)
    end
  end

  def show_flash_message
    flash.collect{ |key,msg| content_tag(:div, msg, :class => key) }.join
  end

  def image_submit_button
    %Q{<input src="/images/submit.png" type="image" />}
  end

  def error_class_on(object, field)
    return "class=\"form-error\"" if !object.errors[field].nil? && object.errors[field].any?
  end
end