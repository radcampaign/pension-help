class CreatePlanCatchAllEmployees < ActiveRecord::Migration
  def self.up
    create_table :plan_catch_all_employees do |t|
      t.column :plan_id, :integer
      t.column :employee_type_id, :integer
      t.column :position, :integer
    end
  end

  def self.down
    drop_table :plan_catch_all_employees
  end
end
