class CreatePartnersPractices < ActiveRecord::Migration
  def self.up
    create_table :partners_practices, :id => false do |t|
      t.column :partner_id, :integer
      t.column :practice_id, :integer
    end
  end

  def self.down
    remove_table :partners_practices
  end
end
