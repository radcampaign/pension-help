class PlanCatchAllEmployee < ActiveRecord::Base
  belongs_to :plan
  belongs_to :employee_type
end
