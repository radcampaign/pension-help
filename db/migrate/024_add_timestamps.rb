class AddTimestamps < ActiveRecord::Migration
  def self.up
    add_column :locations, :updated_by, :string
    add_column :plans, :updated_at, :datetime
    add_column :plans, :updated_by, :string
  end

  def self.down
    remove_column :locations, :updated_by
    remove_column :plans, :updated_at
    remove_column :plans, :updated_by
  end
end
