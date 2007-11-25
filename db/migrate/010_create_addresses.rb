class CreateAddresses < ActiveRecord::Migration
  def self.up
    create_table :addresses do |t|
      t.column :line1, :string
      t.column :line2, :string
      t.column :city, :string, :limit => 64
      t.column :state_abbrev, :string
      t.column :zip, :string
      # t.column :location_id, :integer
      t.column :address_type, :string
    end
  end

  def self.down
    drop_table :addresses
  end
end
