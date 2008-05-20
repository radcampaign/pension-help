class AddAgeRestrictedPhone < ActiveRecord::Migration
  def self.up
    add_column :restrictions, :age_restricted_phone, :string, :limit => 20
  end

  def self.down
    remove_column :restrictions, :age_restricted_phone
  end
end
