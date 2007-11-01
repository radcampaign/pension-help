class CreateAgencies < ActiveRecord::Migration
  def self.up
    create_table :agencies do |t|
      t.column :name, :string
      t.column :name2, :string
      t.column :parent_id, :integer
      t.column :description, :text
      t.column :service_description, :text
      t.column :phone, :string
      t.column :tollfree, :string
      t.column :fax, :string
      t.column :tty, :string
      t.column :url, :string
      t.column :url2, :string
      t.column :email, :string
      t.column :hours_of_operation, :string
      t.column :logistics, :string
      t.column :comments, :text
      t.column :data_source, :string
      t.column :is_active, :bool
      t.column :legacy_code, :string
      t.column :legacy_subcode, :string
      t.column :has_restrictions, :bool
      t.column :has_geo_restrictions, :boolean
      t.column :agency_category_id, :integer
      t.column :agency_type_id, :integer
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
      t.column :updated_by, :string
    end
  end

  def self.down
    drop_table :agencies
  end
end

__END__

load data infile 'agencies.csv' into table agencies fields terminated by ',' enclosed by '"' (name,name2,description,service_description,tollfree,phone,fax,tty,url,url2,email,hours_of_operation,logistics,comments,data_source,is_active,legacy_code,created_at,updated_at,updated_by);

load data infile 'subagencies.csv' into table agencies fields terminated by ',' enclosed by '"' (name,name2,description,service_description,tollfree,phone,fax,tty,url,url2,email,hours_of_operation,logistics,comments,data_source,is_active,legacy_subcode,created_at,updated_at,updated_by,legacy_code);

update agencies a, agencies b set a.parent_id = b.id where a.legacy_code = b.legacy_code;

update agencies set parent_id = null where parent_id = id;