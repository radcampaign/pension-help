class CreateSearchNets < ActiveRecord::Migration
  def self.up
    create_table :search_nets do |t|
      t.column "contact_id", :integer
      t.column "wont_charge_fees", :boolean
      t.column "info_plans", :string
      t.column "info_geo", :string
      t.column "info_industries", :string
      t.column "info_referrals", :string
    end
  end

  def self.down
    drop_table :search_nets
  end
end
