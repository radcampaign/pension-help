class CreateJurisdictions < ActiveRecord::Migration
  def self.up
    create_table :jurisdictions do |t|
      t.column :name, :string
      t.column :position, :integer
    end
    
    create_table :partners_jurisdictions do |t|
      t.column :partner_id, :integer
      t.column :jurisdiction_id, :integer
    end

    sql = <<-SQL
insert into jurisdictions (name, position) values('Alaska', 1), ('Alabama', 2), ('Arkansas', 3), ('Arizona', 4), ('California', 5), ('Colorado', 6), ('Connecticut', 7), ('Delaware', 8), ('Florida', 9), ('Georgia', 10), ('Hawaii', 11), ('Idaho', 12), ('Indiana', 13), ('Illinois', 14), ('Iowa', 15), ('Kansas', 16), ('Kentucky', 17), ('Louisiana', 18), ('Maine', 19), ('Maryland', 20), ('Massachusetts', 21), ('Michigan', 22), ('Minnesota', 23), ('Missouri', 24), ('Mississippi', 25), ('Montana', 26), ('Nebraska', 27), ('Nevada', 28), ('New Hampshire', 29), ('New Jersey', 30), ('New Mexico', 31), ('New York', 32), ('North Carolina', 33), ('North Dakota', 34), ('Oklahoma', 35), ('Ohio', 36), ('Oregon', 37), ('Pennsylvania', 38), ('Rhode Island', 39), ('South Carolina', 40), ('South Dakota', 41), ('Tennessee', 42), ('Texas', 43), ('Utah', 44), ('Vermont', 45), ('Virginia', 46), ('Washington', 47), ('West Virginia', 48), ('Wisconsin', 49), ('Wyoming', 50), ('First Circuit', 51), ('Second Circuit', 52), ('Third Circuit', 53), ('Fourth Circuit', 54), ('Fifth Circuit', 55), ('Sixth Circuit', 56), ('Seventh Circuit', 57), ('Eighth Circuit', 58), ('Ninth Circuit', 59), ('Tenth Circuit', 60), ('Eleventh Circuit', 61), ('D.C. Circuit', 62), ('U.S. Supreme Court', 63);
    SQL
    
    execute sql
  end

  def self.down
    drop_table :partners_jurisdictions
    drop_table :jurisdictions
  end
end
