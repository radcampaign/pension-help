class AlterMonthlyIncomeColumn < ActiveRecord::Migration
  def self.up
    change_column :counselings, :monthly_income, :decimal, :precision => 10, :scale => 2
  end

  def self.down
    change_column :counselings, :monthly_income, :integer
  end
end
