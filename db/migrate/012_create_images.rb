class CreateImages < ActiveRecord::Migration
  def self.up
    create_table :images, :force => true do |t|
      t.column :parent_id,       :integer, :null => true
      t.column :thumbnail,       :string
      t.column :filename,        :string, :limit => 255
      t.column :content_type,    :string, :limit => 255
      t.column :size,            :integer
      t.column :width,           :integer
      t.column :height,          :integer
      t.column :aspect_ratio,    :float
    end
  end

  def self.down
    drop_table :images
  end
end
