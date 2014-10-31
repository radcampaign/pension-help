# == Schema Information
# Schema version: 41
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
  self.table_name = 'zip_import'
  self.primary_key = 'zipcode'
  acts_as_mappable :default_units => :miles, :default_formula => :flat, 
                   :lat_column_name => 'latitude', :lng_column_name => 'longitude'
                   
  # override find to restrict zip to first 5 digits
  def self.find(*args)                   
    args=args.first[0..4] if args.first.is_a?(String) && args.size == 1
    super(args)
  end
  
end
