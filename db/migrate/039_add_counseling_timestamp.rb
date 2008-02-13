class AddCounselingTimestamp < ActiveRecord::Migration
  def self.up
    add_column :counselings, :created_at, :datetime
  end

  def self.down
    remove_column :counselings, :created_at
  end
end
