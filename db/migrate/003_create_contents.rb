class CreateContents < ActiveRecord::Migration
  def self.up
    create_table :contents do |t|
      t.column "url", :string
      t.column "title", :string
      t.column "content", :text
      t.column "created_at", :string
      t.column "updated_at", :datetime
      t.column "updated_by", :string
    end
  end

  def self.down
    drop_table :contents
  end
end

