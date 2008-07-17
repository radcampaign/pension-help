class AddIsActiveToLocationsPlans < ActiveRecord::Migration
  def self.up
    add_column :locations, :is_active, :boolean, :default => true
    add_column :plans, :is_active, :boolean, :default => true

    #Update existinfg Locations and Plans to be active
    Location.update_all 'is_active = 1'
    Plan.update_all 'is_active = 1'
  end

  def self.down
    remove_column :locations, :is_active
    remove_column :plans, :is_active
  end
end
