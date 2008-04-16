class AddAgeAndIncomeToRestrictions < ActiveRecord::Migration
  def self.up
    add_column :restrictions, :age_and_income, :boolean
  end

  def self.down
    remove_column :restrictions, :age_and_income
  end
end
