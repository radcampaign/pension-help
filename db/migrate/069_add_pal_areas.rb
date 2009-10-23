class AddPalAreas < ActiveRecord::Migration
  def self.up
    execute "update pal_additional_areas set position = 1 where name like 'Domestic relations%'"
    execute "update pal_additional_areas set name = 'Pension Benefit Guaranty Corporation', position = 2 where name like 'PBGC%'"
    execute "update pal_additional_areas set position = 3 where name like 'Plan changes%'"
    execute "insert into pal_additional_areas (name, position) values ('Professional service providers', 4)"
    execute "update pal_additional_areas set position = 5 where name like 'Other%'"
  end

  def self.down
  end
end
