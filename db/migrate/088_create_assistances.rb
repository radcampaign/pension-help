class CreateAssistances < ActiveRecord::Migration
  def self.up
    create_table :assistances do |t|
      t.column :name, :string
    end
  end

  def self.down
    drop_table :assistances
  end
end
