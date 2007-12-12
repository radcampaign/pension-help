class AddPartnerNets < ActiveRecord::Migration
  def self.up
    add_column :partners, :wants_npln, :boolean, {:default => false}
    add_column :partners, :wants_pal, :boolean, {:default => false}
    add_column :partners, :wants_help, :boolean, {:default => false}
    add_column :partners, :wants_search, :boolean, {:default => false}
  end

  def self.down
    remove_column :partners, :wants_npln
    remove_column :partners, :wants_pal
    remove_column :partners, :wants_help
    remove_column :partners, :wants_search
  end
end
