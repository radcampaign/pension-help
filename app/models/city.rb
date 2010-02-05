# == Schema Information
# Schema version: 41
#
# Table name: cities
#
#  id           :integer(11)   not null, primary key
#  name         :string(255)   
#  county_id    :integer(11)   
#  state_abbrev :string(255)   
#

class City < ActiveRecord::Base
  belongs_to :county

  def plan_matches
    sql = <<-SQL
        select distinct p.*
        from plans p 
        join agencies a on p.agency_id = a.id
        join restrictions r on r.plan_id = p.id
        join restrictions_cities rc on rc.restriction_id = r.id
        and a.agency_category_id = 3
        and rc.city_id = ?
        and a.use_for_counseling = 1 and a.is_active = 1 and p.is_active = 1
        SQL
    Plan.find_by_sql([sql, id])
  end
  
end
