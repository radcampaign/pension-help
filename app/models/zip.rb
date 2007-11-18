# == Schema Information
# Schema version: 17
#
# Table name: zips
#
#  zipcode      :string(255)   
#  state_abbrev :string(255)   
#

class Zip < ActiveRecord::Base
  self.primary_key = 'zipcode'
end

__END__

These are shell/mysql commands now. They should become a class method that gets called 
from the script/runner through cron.

mysqlimport -u root --columns=zipcode,zip_type,city,city_type,county,county_fips,state_name,state_abbrev,state_fips,msa_code,area_code,time_zone,utc,dst,latitude,longitude --local pha_development zip_import.txt 

Also, these need to be converted to insert/update statements:

mysql> insert into states select distinct state_abbrev, state_name from zip_import;

mysql> insert into counties select distinct null, county, county_fips, state_abbrev from zip_import; 

mysql> insert into zips select distinct zipcode, state_abbrev from zip_import;                      

mysql> insert into cities select distinct null, z.city, c.id, z.state_abbrev from zip_import z join counties c on z.county = c.name and z.state_abbrev=c.state_abbrev;
