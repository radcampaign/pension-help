class AddPositionToPlansLocations < ActiveRecord::Migration
  def self.up
    add_column :locations, :position, :integer
    add_column :plans, :position, :integer
  end

  def self.down
    remove_column :locations, :position
    remove_column :plans, :position
  end
  
end
