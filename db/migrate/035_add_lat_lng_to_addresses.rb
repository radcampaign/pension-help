class AddLatLngToAddresses < ActiveRecord::Migration
  def self.up
    add_column :addresses, :latitude, :decimal, :precision => 9, :scale => 6
    add_column :addresses, :longitude, :decimal, :precision => 9, :scale => 6
    execute 'update addresses a join zip_import z on substring(a.zip, 1, 5) = z.zipcode set a.latitude=z.latitude, a.longitude=z.longitude'
  end

  def self.down
    remove_column :addresses, :latitude
    remove_column :addresses, :longitude
  end
end
