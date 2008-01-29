# == Schema Information
# Schema version: 35
#
# Table name: zip_import
#
#  zipcode      :string(5)     not null, primary key
#  city         :string(64)    
#  county       :string(64)    
#  state_abbrev :string(2)     
#  zip_type     :string(1)     
#  city_type    :string(1)     
#  county_fips  :string(5)     
#  state_name   :string(64)    
#  state_fips   :string(2)     
#  msa_code     :string(4)     
#  area_code    :string(16)    
#  time_zone    :string(16)    
#  utc          :decimal(3, 1) 
#  dst          :boolean(1)    
#  latitude     :decimal(9, 6) 
#  longitude    :decimal(9, 6) 
#

class ZipImport < ActiveRecord::Base
  set_table_name 'zip_import'
  self.primary_key = 'zipcode'
  acts_as_mappable :default_units => :miles, :default_formula => :flat, 
                   :lat_column_name => 'latitude', :lng_column_name => 'longitude'
                   
  # override find to restrict zip to first 5 digits
  def self.find(*args)                   
    args=args.first[0..4] if args.first.is_a?(String) && args.size == 1
    super(args)
  end
  
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
