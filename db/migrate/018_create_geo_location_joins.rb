class CreateGeoLocationJoins < ActiveRecord::Migration
  def self.up
    create_table :locations_states, :id => false do |t|
      t.column :location_id, :integer, :null => false
      t.column :state_abbrev, :string, :limit => 2, :null => false
    end
    execute "alter table locations_states add primary key pk_states(location_id, state_abbrev)"
    add_index :locations_states, [:state_abbrev, :location_id]
    
    create_table :locations_counties, :id => false do |t|
      t.column :location_id, :integer, :null => false
      t.column :county_id, :integer, :null => false
    end 
    execute "alter table locations_counties add primary key pk_states(location_id, county_id)"
    add_index :locations_counties, [:county_id, :location_id]
 
  end

  def self.down
    drop_table :locations_states
    drop_table :locations_counties
  end
end
