class CreateRestrictions < ActiveRecord::Migration
  def self.up
    create_table :restrictions, :force => true do |t|
      t.column :agency_id, :integer
      t.column :location_id, :integer
      t.column :plan_id, :integer
      t.column :minimum_age, :decimal, :precision => 5, :scale => 2
      t.column :max_poverty, :decimal, :precision => 5, :scale => 2
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
      t.column :legacy_code, :string, :limit => 10
      t.column :legacy_subcode, :string, :limit => 10
      t.column :legacy_residency, :string
      t.column :legacy_geo_agency, :text
      t.column :legacy_geo_subagency, :text
    end
    
    create_table :restrictions_states, :id => false do |t|
      t.column :restriction_id, :integer, :null => false
      t.column :state_abbrev, :string, :limit => 2, :null => false
    end
    execute "alter table restrictions_states add primary key pk_states(restriction_id, state_abbrev)"
    add_index :restrictions_states, [:state_abbrev, :restriction_id]
    
    create_table :restrictions_zips, :id => false do |t|
      t.column :restriction_id, :integer, :null => false
      t.column :zipcode, :string, :limit => 5, :null => false
    end  
    execute "alter table restrictions_zips add primary key pk_states(restriction_id, zipcode)"
    add_index :restrictions_zips, [:zipcode, :restriction_id]

    create_table :restrictions_cities, :id => false do |t|
      t.column :restriction_id, :integer, :null => false
      t.column :city_id, :integer, :null => false
    end
    execute "alter table restrictions_cities add primary key pk_states(restriction_id, city_id)"
    add_index :restrictions_cities, [:city_id, :restriction_id]

    create_table :restrictions_counties, :id => false do |t|
      t.column :restriction_id, :integer, :null => false
      t.column :county_id, :integer, :null => false
    end 
    execute "alter table restrictions_counties add primary key pk_states(restriction_id, county_id)"
    add_index :restrictions_counties, [:county_id, :restriction_id]
  end

  def self.down
    drop_table :restrictions_states
    drop_table :restrictions_zips
    drop_table :restrictions_cities
    drop_table :restrictions_counties
    drop_table :restrictions
  end
end

