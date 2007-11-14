class CreateGeoPlanJoins < ActiveRecord::Migration
  def self.up
    create_table :plans_states, :id => false do |t|
      t.column :plan_id, :integer, :null => false
      t.column :state_abbrev, :string, :limit => 2, :null => false
    end
    execute "alter table plans_states add primary key pk_states(plan_id, state_abbrev)"
    add_index :plans_states, [:state_abbrev, :plan_id]
    
    create_table :plans_zips, :id => false do |t|
      t.column :plan_id, :integer, :null => false
      t.column :zipcode, :string, :limit => 5, :null => false
    end  
    execute "alter table plans_zips add primary key pk_states(plan_id, zipcode)"
    add_index :plans_zips, [:zipcode, :plan_id]

    create_table :plans_cities, :id => false do |t|
      t.column :plan_id, :integer, :null => false
      t.column :city_id, :integer, :null => false
    end
    execute "alter table plans_cities add primary key pk_states(plan_id, city_id)"
    add_index :plans_cities, [:city_id, :plan_id]

    create_table :plans_counties, :id => false do |t|
      t.column :plan_id, :integer, :null => false
      t.column :county_id, :integer, :null => false
    end 
    execute "alter table plans_counties add primary key pk_states(plan_id, county_id)"
    add_index :plans_counties, [:county_id, :plan_id]
 
  end

  def self.down
    drop_table :plans_states
    drop_table :plans_zips
    drop_table :plans_cities
    drop_table :plans_counties
  end
end
