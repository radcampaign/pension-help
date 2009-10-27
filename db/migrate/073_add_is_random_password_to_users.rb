class AddIsRandomPasswordToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :is_random_pass, :boolean

  end

  def self.down
    remove_column :users, :is_random_pass

  end
end