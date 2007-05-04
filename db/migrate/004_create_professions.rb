class CreateProfessions < ActiveRecord::Migration
  class Profession < ActiveRecord::Base
  end
  
  def self.up
    create_table :professions do |t|
      t.column "name", :string
      t.column "position", :integer
    end
    Profession.create :position => 1, :name => "Attorney"
    Profession.create :position => 2, :name => "Actuary"
    Profession.create :position => 3, :name => "Accountant"
    Profession.create :position => 4, :name => "Benefits Manager"
    Profession.create :position => 5, :name => "HR Professional"
    Profession.create :position => 6, :name => "Plan Administrator"
    Profession.create :position => 7, :name => "Third-party Administrator"
    Profession.create :position => 8, :name => "Financial Services Provider"
    Profession.create :position => 9, :name => "Financial Planner"
    Profession.create :position => 10, :name => "Other..."
  end

  def self.down
    drop_table :professions
  end
end
