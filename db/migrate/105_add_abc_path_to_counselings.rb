class AddAbcPathToCounselings < ActiveRecord::Migration
  def self.up
    add_column :counselings, :abc_path, :string
  end

  def self.down
    remove_column :counselings, :abc_path
  end
end
