class CreateExpertises < ActiveRecord::Migration
  def self.up
    create_table :expertises do |t|
      t.column :name, :string
    end
  end

  def self.down
    drop_table :expertises
  end
end
