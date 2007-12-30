# == Schema Information
# Schema version: 33
#
# Table name: zips
#
#  zipcode      :string(255)   primary key
#  state_abbrev :string(255)   
#  county_id    :integer(11)   
#

class Zip < ActiveRecord::Base
  self.primary_key = 'zipcode'
end

__END__

http://www.zipcodedownload.com/Products/Product/Z5Commercial/Standard/Schema/

These are shell/mysql commands now. They should become a class method that gets called 
from the script/runner through cron.

mysqlimport5 -u root --ignore-lines=1 --columns=zipcode,zip_type,city,city_type,county,county_fips,state_name,state_abbrev,state_fips,msa_code,area_code,time_zone,utc,dst,latitude,longitude --local pha_development zip_import.txt 

Also, these need to be converted to insert/update statements:

mysql> 
insert into states select distinct state_abbrev, state_name from zip_import;

insert into counties select distinct null, county, county_fips, state_abbrev from zip_import; 

insert into zips select distinct z.zipcode, z.state_abbrev, c.id from zip_import z join counties c on z.county = c.name and z.state_abbrev=c.state_abbrev where z.zip_type = 'S' or z.zip_type = 'P';                      

insert into cities select distinct null, z.city, c.id, z.state_abbrev from zip_import z join counties c on z.county = c.name and z.state_abbrev=c.state_abbrev where z.city_type = 'D' and (z.zip_type = 'S' or z.zip_type = 'P');
