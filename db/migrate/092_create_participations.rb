class CreateParticipations < ActiveRecord::Migration
  def self.up
    create_table :participations do |t|
      t.column :name, :string
    end
  end

  def self.down
    drop_table :participations
  end
end
