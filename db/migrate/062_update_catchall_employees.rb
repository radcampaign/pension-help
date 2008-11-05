class UpdateCatchallEmployees < ActiveRecord::Migration
  
  # this migration needs to be run _after_ the FMP state plan data is imported
  # we grab the catchall_employees from the plans table, and create a plan_catch_all_employee
  # join record for each employee we find.
  def self.up
    Plan.find(:all).each do |plan|
      plan.catchall_employees.split(', ').each do |e|
        unless et=EmployeeType.find_by_name(e)
          et=EmployeeType.new
          et.name = e
          et.save!
        end
        pcae=PlanCatchAllEmployee.new(:employee_type_id => et.id, :plan_id => plan.id)
        plan.plan_catch_all_employees << pcae unless plan.employee_types.include?(et)
      end
    end
    
    remove_column :plans, :catchall_employees
  end

  def self.down
    # No downward migration available
  end
end
