# == Schema Information
# Schema version: 35
#
# Table name: agencies
#
#  id                 :integer(11)   not null, primary key
#  agency_category_id :integer(11)   
#  result_type_id     :integer(11)   
#  name               :string(255)   
#  name2              :string(255)   
#  description        :text          
#  data_source        :string(255)   
#  is_active          :boolean(1)    
#  url                :string(255)   
#  url_title          :string(255)   
#  url2               :string(255)   
#  url2_title         :string(255)   
#  comments           :text          
#  services_provided  :text          
#  use_for_counseling :boolean(1)    
#  created_at         :datetime      
#  updated_at         :datetime      
#  updated_by         :string(255)   
#  legacy_code        :string(10)    
#  legacy_status      :string(255)   
#  legacy_category1   :string(255)   
#  legacy_category2   :string(255)   
#  fmp2_code          :string(10)    
#

class Agency < ActiveRecord::Base
  has_many :locations
  has_many :plans
  has_many :publications
  has_one :publication, :class_name => "Publication"
  has_one :hq, :class_name => "Location", :conditions => "is_hq=1 and is_provider=1"
  has_many :dropin_addresses, :through => :locations, :source => :addresses, :conditions => "address_type = 'dropin' and is_provider=1", :order => "is_hq desc"
  has_many :mailing_addresses, :through => :locations, :source => :addresses, :conditions => "address_type = 'mailing' and is_provider=1", :order => "is_hq desc"
  has_one :restriction

  has_enumerated :agency_category
  has_enumerated :result_type
  
  validates_presence_of(:agency_category)
  validates_presence_of(:name)
  
  def best_location(counseling)
    home_geo_zip = ZipImport.find(counseling.zipcode) if !counseling.zipcode.blank?
    home_state = home_geo_zip.nil? ? '' : home_geo_zip.state_abbrev
    
    # out of state goes to hq
    if hq && home_state != hq.dropin_address.state_abbrev
      return hq
    end
    
    # in-state goes to closest geographically
    addr =dropin_addresses.find(:first, :origin => home_geo_zip, :order => 'distance',
                                  :conditions => 'latitude is not null')
    # return the relevant location instead of the address                                  
    return addr.location if addr 
    
  end
      
end
