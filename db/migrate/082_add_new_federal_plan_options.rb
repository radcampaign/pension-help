class AddNewFederalPlanOptions < ActiveRecord::Migration
  def self.up
    add_column :federal_plans, :parent_id, :integer, :default => nil
    add_column :federal_plans, :associated_plan_id, :integer, :default => nil, :references => :plans
  end

  def self.down
    remove_column :federal_plans, :associated_plan_id
    remove_column :federal_plans, :parent_id
  end
end
