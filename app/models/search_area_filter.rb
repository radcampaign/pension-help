#Helper class or storing request params in session and preparing sql queries for Agencies search
class SearchAreaFilter
  @@PARAM_KEYS = %w[state_abbrevs county_ids city_ids zip_ids]

  def initialize
    @search_params = Hash.new
  end

  def put_params(params)
    clear_params() and return if (!params['clear'].nil?)

    @@PARAM_KEYS.each do |key|
      tab = params[key]
      if !tab.nil?
        if !tab.empty? && !tab[0].blank?
          @search_params[key] = tab
        else
          @search_params[key] = nil
        end
      end
    end
    @search_params[:active] = params[:active]
  end

  def has_any_conditions?
    has_state_condition? || has_county_condition? ||
      has_city_condition? || has_zip_condition?
  end

  def has_state_condition?
    result = !@search_params['state_abbrevs'].nil?
    result
  end

  def has_county_condition?
    !@search_params['county_ids'].nil?
  end

  def has_city_condition?
    !@search_params['city_ids'].nil?
  end  

  def has_zip_condition?
    !@search_params['zip_ids'].nil?
  end

  def is_active?
    @search_params[:active]
  end

  def get_find_locations_query
    query = <<-SQL
      select
          distinct l.*
      from
          locations as l
          left join restrictions as r on l.id = r.location_id
          left JOIN restrictions_states AS rs ON r.id = rs.restriction_id
          left JOIN restrictions_counties AS rcu ON r.id = rcu.restriction_id
          left JOIN restrictions_cities AS rci ON r.id = rci.restriction_id
          left JOIN restrictions_zips AS rz ON r.id = rz.restriction_id
          join agencies as a ON a.id = l.agency_id

    SQL
    
    nation_wide_cond =<<NATION_WIDE_CONDITIONS
        (rs.restriction_id IS NULL AND
            rci.restriction_id IS NULL AND
            rcu.restriction_id IS NULL AND
            rz.restriction_id IS NULL AND
            a.use_for_counseling = 1 AND
            a.is_active = 1 AND
            l.is_provider = 1 )

NATION_WIDE_CONDITIONS

    prepare_sql_query(query, nation_wide_cond, true)
  end
  
  def get_find_plans_query
    query = <<-SQL
      select
          distinct p.*
      from
          plans as p
          left join restrictions as r on p.id = r.plan_id
          left JOIN restrictions_states AS rs ON r.id = rs.restriction_id
          left JOIN restrictions_counties AS rcu ON r.id = rcu.restriction_id
          left JOIN restrictions_cities AS rci ON r.id = rci.restriction_id
          left JOIN restrictions_zips AS rz ON r.id = rz.restriction_id
          join agencies as a ON a.id = p.agency_id

    SQL

    nation_wide_cond =<<NATION_WIDE_CONDITIONS
        (rs.restriction_id IS NULL AND
            rci.restriction_id IS NULL AND
            rcu.restriction_id IS NULL AND
            rz.restriction_id IS NULL AND
            a.use_for_counseling = 1 AND
            a.is_active = 1)

NATION_WIDE_CONDITIONS

    prepare_sql_query(query, nation_wide_cond)
  end

  def get_states
    @search_params['state_abbrevs']
  end

  def get_counties
    @search_params['county_ids']
  end
  
  def get_cities
    @search_params['city_ids']
  end

  def get_zips
    @search_params['zip_ids']
  end

  private

  def clear_params()
    @search_params['state_abbrevs'] = nil
    @search_params['county_ids'] = nil
    @search_params['city_ids'] = nil
    @search_params['zip_ids'] = nil
  end

  @@JOIN_TABLES = {
    'state_abbrevs' => {
      'col' => 'rs.state_abbrev'
    },
    'county_ids' => {
      'col' => 'rcu.county_id'
    },
    'city_ids' => {
      'col' => 'rci.city_id'
    },
    'zip_ids' => {
      'col' => 'rz.zipcode'
      }
  }

  #Prepares array of query and parameters for ActiveRecord's find_by_sql method
  #[query_string, param1, param2, ...]
  def prepare_sql_query(query, nation_wide_cond, is_location = false)
    search_cond_string, cond_params = prepare_search_conditions(is_location)
    cond_str = ''
    if (has_any_conditions?)
      cond_str << ' WHERE '
      cond_str << nation_wide_cond
      cond_str << ' OR (' << search_cond_string << ')'
    else
      cond_str << ' WHERE a.is_active = 1 ' if is_active?
    end

    query << cond_str

    result = []
    result << query
    result.concat(cond_params)

    result
  end

  #prepares query conditions using parameters from AJAX request
  def prepare_search_conditions(is_location)
    cond_params = Array.new
    cond = Array.new

    #for each restriction
    @@PARAM_KEYS.each do |r|
      unless (@search_params[r].nil?)
        cond_tmp = "("
        @search_params[r].each do |elem|
          cond_tmp << "#{@@JOIN_TABLES[r]['col']} = ?"
          cond_params << elem
          cond_tmp << " OR " unless elem == @search_params[r].last
        end
        cond_tmp << ")"
        cond << cond_tmp
      end
    end
    cond << '(a.is_active = 1 )' if is_active? || has_any_conditions?

    #show only providers and C&A if not showing all agencies
    if (has_any_conditions?)
      cond << ' (l.is_provider = 1) ' if is_location
      cond << ' (a.use_for_counseling = 1 ) '
    end

    return [cond.join(' AND '), cond_params]
  end
end
