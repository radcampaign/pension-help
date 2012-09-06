class CreateFeeArrangements < ActiveRecord::Migration
  def self.up
    create_table :fee_arrangements do |t|
      t.column :name, :string
    end
  end

  def self.down
    drop_table :fee_arrangements
  end
end
