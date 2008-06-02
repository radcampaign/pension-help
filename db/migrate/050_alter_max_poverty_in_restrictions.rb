class AlterMaxPovertyInRestrictions < ActiveRecord::Migration
  def self.up
    Restriction.update_all 'max_poverty = max_poverty * 100', 'max_poverty is not null and max_poverty < 10'
    change_column :restrictions, :max_poverty, :integer
    change_column :restrictions, :minimum_age, :integer
  end

  def self.down
    change_column :restrictions, :max_poverty, :decimal, :precision => 5, :scale => 2
    change_column :restrictions, :minimum_age, :decimal, :precision => 5, :scale => 2
    Restriction.update_all 'max_poverty = max_poverty / 100', 'max_poverty is not null'
  end
end
