class CreatePractices < ActiveRecord::Migration
  def self.up
    create_table :practices do |t|
      t.column :name, :string
    end
  end

  def self.down
    drop_table :practices
  end
end
