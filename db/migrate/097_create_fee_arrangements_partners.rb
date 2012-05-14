class CreateFeeArrangementsPartners < ActiveRecord::Migration
  def self.up
    create_table :fee_arrangements_partners, :id => false do |t|
      t.column :partner_id, :integer
      t.column :fee_arrangement_id, :integer
    end
  end

  def self.down
    remove_table :fee_arrangements_partners
  end
end
