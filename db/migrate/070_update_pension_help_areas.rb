class UpdatePensionHelpAreas < ActiveRecord::Migration
  def self.up
    execute "delete from partners_help_additional_areas where help_additional_area_id = (select id from help_additional_areas where name like 'Discrimination%')"
    execute "delete from help_additional_areas where name like 'Discrimination%'"
    execute "delete from partners_help_additional_areas where help_additional_area_id = (select id from help_additional_areas where name like 'benefit claims%')"
    execute "delete from help_additional_areas where name like 'benefit claims%'"
    execute "update help_additional_areas set name='Plan Qualification / Minimum Standards', position=1 where name like 'Minimum standards%'"
    execute "update help_additional_areas set name='Fiduciary Responsibility', position=2 where name like 'Fiduciary%'"
    execute "update help_additional_areas set name='Plan Terminations / Bankruptcy', position=3 where name like 'Terminations%'"
    execute "update help_additional_areas set position=5 where name like 'Domestic relations%'"
    execute "update help_additional_areas set position=6 where name like 'Other%'"
  end

  def self.down
  end
end
