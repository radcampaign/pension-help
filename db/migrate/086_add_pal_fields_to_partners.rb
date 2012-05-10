class AddPalFieldsToPartners < ActiveRecord::Migration
  def self.up
    add_column :partners, :preferred_method_of_contact, :integer
  end

  def self.down
    remove_column :partners, :preferred_method_of_contact
  end
end
