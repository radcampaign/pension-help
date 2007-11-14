class CreateZips < ActiveRecord::Migration
  def self.up
    create_table :zip_import, :id => false, :force => :true do |t|
      t.column :zipcode, :string, :limit => 5, :null => false
      t.column :city, :string, :limit => 64
      t.column :county, :string, :limit => 64
      t.column :state_abbrev, :string, :limit => 2
      t.column :zip_type, :string, :limit => 1
      t.column :city_type, :string, :limit => 1
      t.column :county_fips, :string, :limit => 5
      t.column :state_name, :string, :limit => 64
      t.column :state_fips, :string, :limit => 2
      t.column :msa_code, :string, :limit => 4
      t.column :area_code, :string, :limit => 16
      t.column :time_zone, :string, :limit => 16
      t.column :utc, :decimal, :precision => 3, :scale => 1
      t.column :dst, :boolean
      t.column :latitude, :decimal, :precision => 9, :scale => 6
      t.column :longitude, :decimal, :precision => 9, :scale => 6
    end
    add_index :zip_import, :zipcode
    add_index :zip_import, :city
    add_index :zip_import, :county
    add_index :zip_import, :state_abbrev
    create_table :counties do |t|
      t.column :name, :string
      t.column :fips_code, :string
      t.column :state_abbrev, :string
    end
    create_table :zips, :id => false do |t|
      t.column :zipcode, :string
      t.column :state_abbrev, :string
    end
    create_table :cities do |t|
      t.column :name, :string
      t.column :county_id, :integer
      t.column :state_abbrev, :string
    end
  end

  def self.down
    drop_table :zip_import
    drop_table :counties
    drop_table :zips
    drop_table :cities
  end
end
