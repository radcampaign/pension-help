
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
          l.*
      from
          locations as l
    SQL

    query += " join restrictions as r on l.id = r.location_id " if has_state_condition?
    prepare_sql_query(query, true)
  end
  
  def get_find_plans_query
    query = <<-SQL
      select
          p.*
      from
          plans as p
    SQL

    query += "  join restrictions as r on p.id = r.plan_id " if has_state_condition?
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

  private

  def clear_params()
    @search_params['state_abbrevs'] = nil
    @search_params['county_ids'] = nil
    @search_params['city_ids'] = nil
    @search_params['zip_ids'] = nil
  end

  @@JOIN_TABLES = {
    'state_abbrevs' => {
      'join' => ' JOIN restrictions_states AS rs ON r.id = rs.restriction_id',
      'col' => 'rs.state_abbrev'
    },
    'county_ids' => {
      'join' => ' JOIN restrictions_counties AS rcu ON r.id = rcu.restriction_id',
      'col' => 'rcu.county_id'
    },
    'city_ids' => {
      'join' => ' JOIN restrictions_cities AS rct ON r.id = rct.restriction_id',
      'col' => 'rct.city_id'
    },
    'zip_ids' => {
      'join' => ' JOIN restrictions_zips AS rz ON r.id = rz.restriction_id',
      'col' => 'rz.zipcode'
      }
  }

  def prepare_sql_query(query, is_location = false)
    cond_params = Array.new
    joins = ''
    cond = Array.new

    #for each restriction
    @@PARAM_KEYS.each do |r|
      unless (@search_params[r].nil?)
        joins << @@JOIN_TABLES[r]['join']
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
    cond << ' (l.is_provider = 1) ' if is_location && has_any_conditions?
    cond_str = cond.join(' AND ')
    cond_str = ' WHERE ' + cond_str if cond_str.size > 1

    #insert into query proper joins and conditions
    query << joins << ' '
    query << cond_str << ' '

    result = []
    result << query
    result.concat(cond_params)

    result
  end
end
