class CreateExpertisesPartners < ActiveRecord::Migration
  def self.up
    create_table :expertises_partners, :id => false do |t|
      t.column :expertise_id, :integer
      t.column :partner_id, :integer
    end
  end

  def self.down
    remove_table :expertises_partners
  end
end
