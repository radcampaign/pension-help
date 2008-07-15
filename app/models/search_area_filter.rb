#Helper class or storing request params in session and preparing sql queries for Agencies search
class SearchAreaFilter
  @@PARAM_KEYS = %w[state_abbrevs county_ids city_ids zip_ids]

  def initialize
    @search_params = Hash.new
  end

  def put_params(params)
    if (!params['clear'].nil?)
      @search_params.clear
      return
    end

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
    if params.has_key?(:commit)
      @search_params['active'] = params['active']
      #show agencies with ready_for_counseling = 1,or
      #ready_for_counseling = 0, or
      #do not consider this flag
      @search_params['counseling'] = params['counseling']
      #filter on Agency category(Government, Service Provider, ...)
      @search_params['agency_category_id'] = params['agency_category_id']
    end
  end

  def has_any_conditions?
    has_state_condition? || has_county_condition? ||
      has_city_condition? || has_zip_condition? || has_category_condition?
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
    @search_params['active']
  end

  def has_counseling_condition?
    !@search_params['counseling'].blank?
  end

  def has_category_condition?
    !@search_params['agency_category_id'].blank?
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

    prepare_sql_query(query, true)
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

    prepare_sql_query(query)
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
  
  def get_category
    @search_params['agency_category_id']
  end

  def prepare_counseling_condition
    result = ' (a.use_for_counseling ='
    result << (@search_params['counseling'] == '1' ? '1' : '0')
    result << ') '
    return result
  end

  def prepare_category_condition
    return ' (a.agency_category_id = ?) ' , @search_params['agency_category_id']
  end

  #Prepares sql condition which selects Nation Wide Agencies
  def prepare_nation_wide_condition(is_location = false)
    sql_params = Array.new

    sql_cond = '(rs.restriction_id IS NULL AND'
    sql_cond << ' rci.restriction_id IS NULL AND'
    sql_cond << ' rcu.restriction_id IS NULL AND'
    sql_cond << ' rz.restriction_id IS NULL'
    sql_cond << " AND #{prepare_counseling_condition}" if has_counseling_condition?
    sql_cond << " AND a.is_active = 1" if is_active?
    sql_cond << " AND l.is_provider = 1" if is_location

    if has_category_condition?
      s, p = prepare_category_condition
      sql_cond << ' AND ' << s
      sql_params << p
    end
    sql_cond << ") \n"
    return sql_cond, sql_params
  end

  private

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
  def prepare_sql_query(query, is_location = false)
    search_cond_string, search_cond_params = prepare_search_conditions(is_location)
    n_wide_cond, n_wide_params = prepare_nation_wide_condition(is_location)

    cond_params = Array.new
    cond_str = ''
    if (has_any_conditions?)
      cond_str << ' WHERE '
      cond_str << n_wide_cond
      cond_str << ' OR (' << search_cond_string << ')'
      cond_params.concat(n_wide_params)
      cond_params.concat(search_cond_params)
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
    cond << '(a.is_active = 1 )' if is_active?# || has_any_conditions?

    cond << prepare_counseling_condition if has_counseling_condition?
    if (has_category_condition?)
      sql_q, sql_p = prepare_category_condition
      cond << sql_q
      cond_params << sql_p
    end

    return [cond.join(' AND '), cond_params]
  end
end
