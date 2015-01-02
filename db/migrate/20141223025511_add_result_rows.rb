class AddResultRows < ActiveRecord::Migration
  def change
    create_table "result_rows", force: true do |t|
      t.integer "location_id",   null: false
      t.integer "counseling_id", null: false
    end
  end
end
