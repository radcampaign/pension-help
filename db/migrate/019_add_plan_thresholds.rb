class AddPlanThresholds < ActiveRecord::Migration
  def self.up
    add_column :plans, :age_threshold, :decimal, :precision => 5, :scale => 2
    add_column :plans, :income_threshold, :decimal, :precision => 9, :scale => 2
    add_column :agencies, :plan_category_id, :integer
    execute 'update agencies a, plans p set a.plan_category_id = p.plan_category_id where p.agency_id = a.id'
    remove_column :plans, :plan_category_id
  end

  def self.down
    remove_column :plans, :age_threshold
    remove_column :plans, :income_threshold
    add_column :plans, :plan_category_id, :integer
    execute 'update agencies a, plans p set p.plan_category_id = a.plan_category_id where p.agency_id = a.id'    
    remove_column :agencies, :plan_category_id
  end
end
