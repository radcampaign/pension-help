class CreateHelpNets < ActiveRecord::Migration
  def self.up
    create_table :help_nets do |t|
      t.column "contact_id", :integer
      t.column "exp_erisa_single", :boolean
      t.column "exp_erisa_multi", :boolean
      t.column "exp_fed", :boolean
      t.column "exp_state", :boolean
      t.column "exp_church", :boolean
      t.column "exp_other", :string
      t.column "other_info", :string
      t.column "wont_charge_fees", :boolean
    end
  end

  def self.down
    drop_table :help_nets
  end
end
