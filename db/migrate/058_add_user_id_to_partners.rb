class AddUserIdToPartners < ActiveRecord::Migration
  def self.up
    add_column :partners, :user_id, :integer
  end

  def self.down
    remove_column :partners, :user_id
  end
end
