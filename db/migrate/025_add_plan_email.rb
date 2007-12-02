class AddPlanEmail < ActiveRecord::Migration
  def self.up
    add_column :plans, :email, :string
  end

  def self.down
    remove_column :plans, :email
  end
end
