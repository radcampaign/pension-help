# == Schema Information
# Schema version: 33
#
# Table name: restrictions
#
#  id                 :integer(11)   not null, primary key
#  agency_id          :integer(11)   
#  location_id        :integer(11)   
#  plan_id            :integer(11)   
#  minimum_age        :decimal(5, 2) 
#  max_poverty        :decimal(5, 2) 
#  special_district   :string(255)   
#  other_restrictions :text          
#  created_at         :datetime      
#  updated_at         :datetime      
#  legacy_geo_type    :string(255)   
#  legacy_geo_states  :string(255)   
#  legacy_geo_other   :text          
#  legacy_code        :string(10)    
#  legacy_subcode     :string(10)    
#  fmp2_code          :string(10)    
#

class Restriction < ActiveRecord::Base
  belongs_to :agency
  belongs_to :location
  belongs_to :plan
  
  has_and_belongs_to_many :states, :join_table => "restrictions_states", :association_foreign_key => "state_abbrev"
  has_and_belongs_to_many :zips, :join_table => "restrictions_zips", :association_foreign_key => "zipcode"
  has_and_belongs_to_many :cities, :join_table => "restrictions_cities"
  has_and_belongs_to_many :counties, :join_table => "restrictions_counties"
  
  def state_abbrevs
    states.collect(&:abbrev)
  end
  
  def county_ids
    counties.collect(&:id)
  end
  
  def city_ids
    cities.collect(&:id)
  end
  
  def zip_ids
    zips.collect(&:zipcode)
  end

end
