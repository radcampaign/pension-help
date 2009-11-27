class AddColumnsToCounseling < ActiveRecord::Migration
  def self.up
    add_column :counselings, :plan_name, :string
    add_column :counselings, :agency_name, :string
    add_column :counselings, :job_function, :string

  end

  def self.down
    remove_column :counselings, :plan_name
    remove_column :counselings, :agency_name
    remove_column :counselings, :job_function
  end
end
