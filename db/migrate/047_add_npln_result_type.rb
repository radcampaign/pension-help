class AddNplnResultType < ActiveRecord::Migration
  def self.up
    execute 'INSERT INTO result_types (id, name, position) VALUES (21,"NPLN", 21)'
    execute 'UPDATE result_types SET position=99 where name="Other"'
  end

  def self.down
    execute 'DELETE from result_types where name="NPLN" '
  end
end
