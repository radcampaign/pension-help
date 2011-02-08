class FixPlanGovtEmployeeTypeColumn < ActiveRecord::Migration
  def self.up
    add_column :plans, :previous_gov_employee, :string
    Plan.find(:all, :conditions => "govt_employee_type IS NOT NULL").each do |plan|
      plan.previous_gov_employee = plan.govt_employee_type #for backup, just in case
      plan.govt_employee_type = plan.govt_employee_type.gsub("\v",', ') #yes, this is vertical tab in ruby console
      plan.save(false)
    end
  end

  def self.down
    Plan.find(:all, :conditions => "govt_employee_type IS NOT NULL").each do |plan|
      plan.govt_employee_type = plan.previous_gov_employee
      plan.previous_gov_employee = nil
      plan.save(false)
    end
    remove_column :plans, :previous_gov_employee
  end
end
