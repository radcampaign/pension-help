class AddCountyToZip < ActiveRecord::Migration
  def self.up
    add_column :zips, :county_id, :integer
  end

  def self.down
    remove_column :zips, :county_id
  end
end
