class AddFormToExpertises < ActiveRecord::Migration
  def self.up
    add_column :expertises, :form, :string
  end

  def self.down
    remove_column :expertises, :form
  end
end
