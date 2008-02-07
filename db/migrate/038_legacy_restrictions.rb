class LegacyRestrictions < ActiveRecord::Migration
  def self.up
    remove_column :restrictions, :legacy_geo_type
    remove_column :restrictions, :legacy_geo_other
    add_column :restrictions, :legacy_geo_counties, :text
    add_column :restrictions, :legacy_geo_cities, :text
  end

  def self.down
    add_column :restrictions, :legacy_geo_type,    :string
    add_column :restrictions, :legacy_geo_other,   :text
    remove_column :restrictions, :legacy_geo_counties
    remove_column :restrictions, :legacy_geo_cities
  end
end
