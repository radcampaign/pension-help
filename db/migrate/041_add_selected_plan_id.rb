class AddSelectedPlanId < ActiveRecord::Migration
  def self.up
    add_column :counselings, :selected_plan_id, :integer, :references => :plans
  end

  def self.down
    remove_column :counselings, :selected_plan_id
  end
end
