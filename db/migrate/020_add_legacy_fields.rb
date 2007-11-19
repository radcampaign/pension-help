class AddLegacyFields < ActiveRecord::Migration
  def self.up
    add_column :plans, :legacy_category, :string
    add_column :locations, :legacy_code, :string
    add_column :addresses, :legacy_code, :string
    add_column :addresses, :legacy_subcode, :string
    add_column :publications, :legacy_code, :string
    add_column :plans, :legacy_code, :string
    add_column :plans, :legacy_geo_type, :string
    add_column :plans, :legacy_geo_info, :string
    add_column :plans, :legacy_geo_states, :string
    add_column :plans, :legacy_geo_counties, :string
  end

  def self.down
    remove_column :plans, :legacy_category
    remove_column :locations, :legacy_code
    remove_column :addresses, :legacy_code
    remove_column :addresses, :legacy_subcode
    remove_column :publications, :legacy_code
    remove_column :plans, :legacy_code
    remove_column :plans, :legacy_geo_type
    remove_column :plans, :legacy_geo_info
    remove_column :plans, :legacy_geo_states
    remove_column :plans, :legacy_geo_counties
  end
end
