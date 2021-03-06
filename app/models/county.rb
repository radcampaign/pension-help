# == Schema Information
#
# Table name: counties
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  fips_code    :string(255)
#  state_abbrev :string(255)
#

class County < ActiveRecord::Base
  belongs_to :state
  has_many :cities
  has_many :zips

  def plan_matches
    sql = <<-SQL
        select distinct p.*
        from plans p 
        join agencies a on p.agency_id = a.id
        join restrictions r on r.plan_id = p.id
        join restrictions_counties rc on rc.restriction_id = r.id
        and a.agency_category_id = 3
        and rc.county_id = ?
        and a.use_for_counseling = 1 and a.is_active = 1 and p.is_active = 1
        SQL
    Plan.find_by_sql([sql, id])
  end

end
