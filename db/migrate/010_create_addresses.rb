class CreateAddresses < ActiveRecord::Migration
  def self.up
    create_table :addresses do |t|
      t.column :line1, :string
      t.column :line2, :string
      t.column :city, :string
      t.column :state_abbrev, :string
      t.column :zip, :string
      t.column :agency_id, :integer
      t.column :address_type_id, :integer
    end
  end

  def self.down
    drop_table :addresses
  end
end

__END__
## Agencies
alter table addresses add column legacy_code varchar(255);

load data infile 'agency_addresses.csv' into table addresses fields terminated by ',' enclosed by '"' (line1, line2, city, state_abbrev, zip, @null, @null, @null, @null, @null, legacy_code) set address_type_id = 1;

update agencies ag join addresses ad on ad.legacy_code = ag.legacy_code and ag.legacy_subcode is null set ad.agency_id = ag.id;
update addresses set legacy_code = null;

load data infile 'agency_addresses.csv' into table addresses fields terminated by ',' enclosed by '"' (@null, @null, @null, @null, @null, line1, line2, city, state_abbrev, zip, legacy_code) set address_type_id = 2;

update agencies ag join addresses ad on ad.legacy_code = ag.legacy_code and ag.legacy_subcode is null set ad.agency_id = ag.id;
update addresses set legacy_code = null;

## SubAgencies
load data infile 'subagency_addresses.csv' into table addresses fields terminated by ',' enclosed by '"' (line1, line2, city, state_abbrev, zip, @null, @null, @null, @null, @null, legacy_code) set address_type_id = 1;

update agencies ag join addresses ad on ad.legacy_code = ag.legacy_subcode set ad.agency_id = ag.id;
update addresses set legacy_code = null;

load data infile 'subagency_addresses.csv' into table addresses fields terminated by ',' enclosed by '"' (@null, @null, @null, @null, @null, line1, line2, city, state_abbrev, zip, legacy_code) set address_type_id = 2;

update agencies ag join addresses ad on ad.legacy_code = ag.legacy_subcode set ad.agency_id = ag.id;
update addresses set legacy_code = null;

alter table addresses drop column legacy_code;
