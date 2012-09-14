class ChangeOrderOfEmpTypes < ActiveRecord::Migration
  def self.up
    execute "UPDATE employer_types SET position = 1 WHERE name LIKE 'Company%'"
    execute "UPDATE employer_types SET position = 2 WHERE name LIKE 'Federal agency%'"
    execute "UPDATE employer_types SET position = 3 WHERE name LIKE 'Uniformed Services%'"
    execute "UPDATE employer_types SET position = 4 WHERE name LIKE 'Railroad%'"
    execute "UPDATE employer_types SET position = 5 WHERE name LIKE 'Religious%'"
    execute "UPDATE employer_types SET position = 6 WHERE name LIKE 'State agency%'"
    execute "UPDATE employer_types SET position = 7 WHERE name LIKE 'County agency%'"
    execute "UPDATE employer_types SET position = 8 WHERE name LIKE 'City%'"
    execute "UPDATE employer_types SET position = 9 WHERE name LIKE 'Farm Credit%'"
    execute "UPDATE employer_types SET position = 10 WHERE name LIKE 'Other%'"
  end

  def self.down
  end
end
