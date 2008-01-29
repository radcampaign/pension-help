class AddUrlsToLocations < ActiveRecord::Migration
  def self.up
    add_column :locations, :url, :string
    add_column :locations, :url_title, :string
    add_column :locations, :url2, :string
    add_column :locations, :url2_title, :string
  end

  def self.down
    remove_column :locations, :url
    remove_column :locations, :url_title
    remove_column :locations, :url2
    remove_column :locations, :url2_title
  end
end
