class CreateGeoAreas < ActiveRecord::Migration
  def self.up
    create_table :geo_areas do |t|
      t.column :name, :string
      t.column :position, :integer
    end

    create_table :partners_geo_areas do |t|
      t.column :partner_id, :integer
      t.column :geo_area_id, :integer
    end

    sql = <<-SQL
    insert into geo_areas (name, position) values
		('Connecticut', 1),
		('Maine', 2),
		('Massachusetts', 3),
		('New Hampshire', 4),
		('Rhode Island', 5),
		('Vermont', 6),

		('Delaware', 7),
		('Maryland', 8),
		('New Jersey', 9),
		('New York', 10),
		('Pennsylvania', 11),
		('Virginia', 12),
		('West Virginia', 13),

		('Alabama', 14),
		('Arkansas', 15),
		('Florida', 16),
		('Georgia', 17),
		('Kentucky', 18),
		('Louisiana', 19),
		('Mississippi', 20),
		('Oklahoma', 21),
		('North Carolina', 22),
		('South Carolina', 23),
		('Tennessee', 24),
		('Texas', 25),

		('Indiana', 26),
		('Illinois', 27),
		('Iowa', 28),
		('Kansas', 29),
		('Michigan', 30),
		('Minnesota', 31),
		('Missouri', 32),
		('Nebraska', 33),
		('North Dakota', 34),
		('Ohio', 35),
		('South Dakota', 36),
		('Wisconsin', 37),

    ('Alaska', 38),
		('Idaho', 39),
		('Montana', 40),
		('Oregon', 41),
		('Washington', 42),
		('Wyoming', 43),

		('Arizona', 44),
		('California', 45),
		('Colorado', 46),
		('Hawaii', 47),
		('Nevada', 48),
		('New Mexico', 49),
		('Utah', 50);
    SQL

    execute sql
  end

  def self.down
    drop_table :partners_geo_areas
    drop_table :geo_areas
  end
end
