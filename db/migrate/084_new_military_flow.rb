class NewMilitaryFlow < ActiveRecord::Migration

  def self.up
    MilitaryService.enumeration_model_updates_permitted = true
    add_column :military_services, :is_active, :boolean, :default => true

    execute "UPDATE employer_types SET name = 'Uniformed services' where name = 'Military'"


    execute "UPDATE military_services SET is_active = 0 where name = 'Uniformed Services Active duty'"
    execute "UPDATE military_services SET is_active = 0 where name = 'Armed Services Ready Reserve'"
    execute "UPDATE military_services SET is_active = 0 where name = 'Armed Services National Guard'"
    execute "UPDATE military_services SET is_active = 0 where name = 'Civilian military employment'"
    MilitaryService.create(:id => 6, :name => 'Uniformed Services member plans', :position => 1 )
    MilitaryService.create(:id => 7, :name => 'Military Court of Appeals Judges plans', :position => 2)
    MilitaryService.create(:id => 8, :name => 'Civilian employee (NAF and other) plans', :position => 3)

    execute "UPDATE military_branches SET name = 'Army and Army National Guard' where name = 'Army'"
    execute "UPDATE military_branches SET name = 'Air Force and Air National Guard' where name = 'Air Force'"
    execute "UPDATE military_branches SET position = 9 where name = 'I don&rsquo;t know'"
    execute "INSERT into military_branches (name, position) VALUES ('Thrift Savings Plan', 8)"
  end

  def self.down
    execute "UPDATE military_branches SET name = 'Army' where name = 'Army and Army National Guard'"
    execute "UPDATE military_branches SET name = 'Air Force' where name = 'Air Force and Air National Guard'"
    execute "UPDATE military_branches SET position = 8  where name = 'I don&rsquo;t know'"
    execute "DELETE from military_branches where name = 'Thrift Savings Plan'"

    execute "UPDATE military_services SET is_active = 1 where name = 'Uniformed Services Active duty'"
    execute "UPDATE military_services SET is_active = 1 where name = 'Armed Services Ready Reserve'"
    execute "UPDATE military_services SET is_active = 1 where name = 'Armed Services National Guard'"
    execute "UPDATE military_services SET is_active = 1 where name = 'Civilian military employment'"
    MilitaryService.destroy_all(:name => 'Uniformed Services member plans' )
    MilitaryService.destroy_all(:name => 'Military Court of Appeals Judges plans')
    MilitaryService.destroy_all(:name => 'Civilian employee (NAF and other) plans')

    execute "UPDATE employer_types SET name = 'Military' where name = 'Uniformed services'"
  end
end
