# == Schema Information
# Schema version: 41
#
# Table name: restrictions
#
#  id                  :integer(11)   not null, primary key
#  agency_id           :integer(11)   
#  location_id         :integer(11)   
#  plan_id             :integer(11)   
#  minimum_age         :decimal(5, 2) 
#  max_poverty         :decimal(5, 2) 
#  special_district    :string(255)   
#  other_restrictions  :text          
#  created_at          :datetime      
#  updated_at          :datetime      
#  legacy_geo_states   :string(255)   
#  legacy_code         :string(10)    
#  legacy_subcode      :string(10)    
#  fmp2_code           :string(10)    
#  legacy_geo_counties :text          
#  legacy_geo_cities   :text          
#

class Restriction < ActiveRecord::Base
  belongs_to :agency
  belongs_to :location
  belongs_to :plan
  
  has_and_belongs_to_many :states, :join_table => "restrictions_states", :association_foreign_key => "state_abbrev"
  has_and_belongs_to_many :zips, :join_table => "restrictions_zips", :association_foreign_key => "zipcode"
  has_and_belongs_to_many :cities, :join_table => "restrictions_cities"
  has_and_belongs_to_many :counties, :join_table => "restrictions_counties"
  
  #Used in view
  #mark restriction for removing
  attr_accessor :delete_marker
  #java script marks restriction to be saved as a new
  attr_accessor :create_new
  
  def should_be_destroyed?
    delete_marker.to_i == 1
  end
  
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

  #creates a new restriction from request params, or returns nil if restriction is empty.
  def Restriction.create_restriction(params)
    restriction = Restriction.new(params[:restriction])
    restriction.states=( params[:state_abbrevs].to_s.blank? ? [] : params[:state_abbrevs].collect{|s| State.find(s)} ) unless params[:state_abbrevs].nil?
    restriction.counties = ( params[:county_ids].to_s.blank? ? [] : params[:county_ids].collect{|c| County.find(c)} ) unless params[:county_ids].nil?
    restriction.cities=( params[:city_ids].to_s.blank? ? [] : params[:city_ids].collect{|c| City.find(c)} ) unless params[:city_ids].nil?
    restriction.zips=( params[:zip_ids].to_s.blank? ? [] : params[:zip_ids].collect{|c| Zip.find(c)} ) unless params[:zip_ids].nil?
    return (restriction.empty?) ? nil : restriction
  end
  
  #updates restriction from request params.
  def update_restriction(params)
    self.attributes = params[:restriction]
    self.states=( params[:state_abbrevs].to_s.blank? ? [] : params[:state_abbrevs].collect{|s| State.find(s)} ) unless params[:state_abbrevs].nil?
    self.counties = ( params[:county_ids].to_s.blank? ? [] : params[:county_ids].collect{|c| County.find(c)} ) unless params[:county_ids].nil?
    self.cities=( params[:city_ids].to_s.blank? ? [] : params[:city_ids].collect{|c| City.find(c)} ) unless params[:city_ids].nil?
    self.zips=( params[:zip_ids].to_s.blank? ? [] : params[:zip_ids].collect{|c| Zip.find(c)} ) unless params[:zip_ids].nil?
  end

  #Checks if this restriction is 'empty' (all attributes blank, all collections empty)
  def empty?
    result = true
    attribute_names().each do |attr|
      unless (attributes[attr].blank?)
        result = false
      end
    end

    if !states.empty? || !counties.empty? || !cities.empty? || !zips.empty?
      result = false
    end
    return result
  end
end
