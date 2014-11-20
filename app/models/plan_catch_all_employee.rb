# == Schema Information
#
# Table name: plan_catch_all_employees
#
#  id               :integer          not null, primary key
#  plan_id          :integer
#  employee_type_id :integer
#  position         :integer
#

class PlanCatchAllEmployee < ActiveRecord::Base
  belongs_to :plan
  belongs_to :employee_type
end
