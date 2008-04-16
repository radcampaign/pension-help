class AddPhaContactToLocations < ActiveRecord::Migration
  def self.up
    add_column :locations, :pha_contact_name, :string
    add_column :locations, :pha_contact_title, :string
    add_column :locations, :pha_contact_phone, :string, :limit => 20
    add_column :locations, :pha_contact_email, :string
  end

  def self.down
    remove_column :locations, :pha_contact_name
    remove_column :locations, :pha_contact_title
    remove_column :locations, :pha_contact_phone
    remove_column :locations, :pha_contact_email
  end
end
