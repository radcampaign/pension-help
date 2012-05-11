class AddNplnFieldsToPartners < ActiveRecord::Migration
  def self.up
    add_column :partners, :dr_lawyer, :boolean, :default => false
    add_column :partners, :has_other_level_of_participation, :boolean, :default => false
    add_column :partners, :other_level_of_participation, :string
    add_column :partners, :law_practice_states, :string
    add_column :partners, :law_practice_circuts, :string
    add_column :partners, :us_supreme_court, :boolean, :default => false
    add_column :partners, :malpractice_insurance, :boolean, :default => false
  end

  def self.down
    remove_column :partners, :dr_lawyer
    remove_column :partners, :has_other_level_of_participation
    remove_column :partners, :other_level_of_participation
    remove_column :partners, :law_practice_states
    remove_column :partners, :law_practice_circuts
    remove_column :partners, :us_supreme_court
    remove_column :partners, :malpractice_insurance
  end
end
