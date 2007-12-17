class AddNewsPosition < ActiveRecord::Migration
  def self.up
    add_column :news, :position, :integer
  end

  def self.down
    remove_column :news, :position
  end
end
