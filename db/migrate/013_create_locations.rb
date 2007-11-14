class CreateLocations < ActiveRecord::Migration
  def self.up
    create_table :locations do |t|
      t.column :name, :string
      t.column :is_hq, :boolean
      t.column :agency_id, :integer
      t.column :phone, :string, :limit => 20
      t.column :phone_ext, :string, :limit => 10
      t.column :tollfree, :string, :limit => 20
      t.column :tollfree_ext, :string, :limit => 10
      t.column :fax, :string, :limit => 20
      t.column :tty, :string, :limit => 20
      t.column :tty_ext, :string, :limit => 10
      t.column :email, :string
      t.column :hours_of_operation, :string
      t.column :logistics, :string
      t.column :legacy_subcode, :string, :limit => 10
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
      t.column :updated_by, :string
    end
    add_column :addresses, :location_id, :integer
  end

  def self.down
    drop_table :locations
    remove_column :addresses, :location_id
  end
end

