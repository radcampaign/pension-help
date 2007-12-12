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
  
end
