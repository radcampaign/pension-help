class AddNewFormFields < ActiveRecord::Migration
  def self.up
    add_column :counselings, :behalf, :string
    add_column :counselings, :behalf_other, :string
    add_column :counselings, :gender, :string
    add_column :counselings, :marital_status, :string
    add_column :counselings, :age, :integer
    add_column :counselings, :ethnicity, :string
  end

  def self.down
    # nothing here
  end
end
