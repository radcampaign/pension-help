# == Schema Information
# Schema version: 23
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
  has_many :dropin_addresses, :through => :locations, :source => :addresses, :conditions => "address_type = 'dropin' and is_hq=1", :limit => 1
  has_many :mailing_addresses, :through => :locations, :source => :addresses, :conditions => "address_type = 'mailing' and is_hq=1", :limit => 1
  has_many :restrictions

  has_enumerated :agency_category
  has_enumerated :result_type
  
  validates_presence_of(:agency_category)
  validates_presence_of(:name)
  
  def show_plans?
    # [13, 14].include?(self.plan_category_id)
  end
  
end
