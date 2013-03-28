class AddFieldsToPartners < ActiveRecord::Migration
  def self.up
    add_column :partners, :tollfree_number, :string
    add_column :partners, :local_number, :string
    add_column :partners, :office_location, :text
    add_column :partners, :wants_lsp, :boolean, :default => false
  end

  def self.down
    remove_column :partners, :tollfree_number
    remove_column :partners, :local_number
    remove_column :partners, :office_location
    remove_column :partners, :wants_lsp
  end
end
