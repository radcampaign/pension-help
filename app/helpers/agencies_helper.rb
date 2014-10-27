module AgenciesHelper

  #Prepares link_to_remote for Served Area page,
  #options contains new values for params, or markers for omitting those params
  def agencies_filter_link_to_remote(label, params, options = {})
    link_to_remote label,
        :update => 'search_results',
        :url => prepare_url_params(params, options),
        :before => "Element.show('spinner')",
        :complete => "Element.hide('spinner')"
  end

  def agencies_filter_button_to_remote(label, params, options = {})
    function = remote_function(:update => 'search_results',
        :url => prepare_url_params(params, options),
        :before => "Element.show('spinner')",
        :complete => "Element.hide('spinner')")

    "<input type=\"button\" name=\"\" value=\"#{label}\" onclick=\"#{function}\" />"
  end

  def agencies_filter_button_to_clear()
    button =<<-END_BUTTON
    <form class="button-to" action="/agencies" method="get">
      <div>
      <input type="hidden" name="clear" value="true" />
      <input type="submit" name="submit" value="Show all agencies" />
      </div>
    </form>
    END_BUTTON
    return button
  end

  private
  def prepare_url_params params, options
    url = Hash.new
    #these params does not change
    url[:action] = :ajax_search
    url[:report] = 'search'

    SEARCH_PARAMS.each do |param|
      #this param's value should be replaced
      if options.has_key?(param)
        #replace default value of param or ommit param (eg if options[:active] = nil do not add this params to hash)
        url[param] = options[param] unless options[param].nil?
      else
        url[param] = params[param]
      end
    end
    return url
  end

  SEARCH_PARAMS = [
    :state_abbrevs, :county_ids, :city_ids, :zip_ids, :order,
    :active, :desc, :counseling, :agency_category_id, :provider, :commit,
    :agency_name
  ]
end
