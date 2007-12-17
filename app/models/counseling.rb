class Counseling < ActiveRecord::Base
  has_enumerated :pension_earner
  has_enumerated :employer_type
  has_enumerated :federal_plan
  has_enumerated :military_service
  has_enumerated :military_branch
  has_enumerated :military_employer
  belongs_to :city
  belongs_to :county
  belongs_to :state
  belongs_to :work_state, :class_name => "State", :foreign_key => "work_state_abbrev"
  belongs_to :hq_state, :class_name => "State", :foreign_key => "hq_state_abbrev"
  belongs_to :pension_state, :class_name => "State", :foreign_key => "pension_state_abbrev"
  
  def has_aoa_coverage?
    sql = <<-SQL
        select 1 from agencies a 
        join locations l on l.agency_id = a.id 
        join restrictions r on r.location_id = l.id or r.agency_id = a.id 
        join restrictions_states rs on rs.restriction_id = r.id 
        where a.result_type_id = ? and rs.state_abbrev = ?
        SQL
    Agency.find_by_sql([sql, ResultType['AoA'], state_abbrev]).size > 0
  end
  
end
