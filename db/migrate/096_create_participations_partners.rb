class CreateParticipationsPartners < ActiveRecord::Migration
  def self.up
    create_table :participations_partners, :id => false do |t|
      t.column :partner_id, :integer
      t.column :participations_id, :integer
    end
  end

  def self.down
    remove_table :participations_partners
  end
end
