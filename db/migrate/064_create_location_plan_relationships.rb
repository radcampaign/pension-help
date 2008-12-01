class CreateLocationPlanRelationships < ActiveRecord::Migration
  def self.up
    create_table :location_plan_relationships do |t|
      t.column :location_id, :integer
      t.column :plan_id, :integer
      t.column :is_hq, :boolean
    end
  end

  def self.down
    drop_table :location_plan_relationships
  end
end
