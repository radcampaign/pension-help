class AddAfscmeMember < ActiveRecord::Migration
  def self.up
    add_column :counselings, :is_afscme_member, :boolean
  end

  def self.down
    remove_column :counselings, :is_afscme_member
  end
end
