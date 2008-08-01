class AddCitiesZipsTable < ActiveRecord::Migration
  def self.up
    create_table :cities_zips, :id => false, :force => true do |t|
      t.column :city_id, :int, :null => false
      t.column :zipcode, :string, :limit => 5, :null => false
      t.column :city_type, :string, :limit => 1
    end
    execute "alter table cities_zips add primary key pk_cities_zips(city_id, zipcode)"
    execute "alter table zips add primary key pk_zips(zipcode)"
    execute "alter table zip_import modify column dst char(1)"
    add_index "cities_zips", ["zipcode", "city_id"], :name => "idx_cities_zips_on_zip_and_city"
    
    add_index :counties, [:fips_code, :state_abbrev], :unique => true
    add_index :cities, [:name, :county_id], :unique => true
  end

  def self.down
    drop_table :cities_zips
    remove_index :counties, :column => [:fips_code, :state_abbrev]
    remove_index :cities, :column =>  [:name, :county_id]
    execute "alter table zips drop primary key"
  end
end
