class CreateAssistancesPartners < ActiveRecord::Migration
  def self.up
    create_table :assistances_partners, :id => false do |t|
      t.column :partner_id, :integer
      t.column :assistance_id, :integer
    end
  end

  def self.down
    remove_table :assistances_partners
  end
end
