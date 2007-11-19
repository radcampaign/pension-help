class CreateAgencies < ActiveRecord::Migration
  def self.up
    create_table :agencies do |t|
      t.column :name, :string
      t.column :name2, :string
      t.column :data_source, :string
      t.column :is_active, :bool
      t.column :url, :string
      t.column :url_title, :string
      t.column :legacy_code, :string
      t.column :legacy_subcode, :string
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
      t.column :updated_by, :string
    end
  end

  def self.down
    drop_table :agencies
  end
end
