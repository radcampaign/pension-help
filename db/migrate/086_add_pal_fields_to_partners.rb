class AddPalFieldsToPartners < ActiveRecord::Migration
  def self.up
    add_column :partners, :preferred_method_of_contact,                  :integer
    add_column :partners, :fee_for_initial_consultation,                 :string
    add_column :partners, :hourly_continuous_fee,                        :string
    add_column :partners, :professional_certifications_and_affiliations, :string
  end

  def self.down
    remove_column :partners, :preferred_method_of_contact
    remove_column :partners, :fee_for_initial_consultation
    remove_column :partners, :hourly_continuous_fee
    remove_column :partners, :professional_certifications_and_affiliations
  end
end
