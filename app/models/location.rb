# == Schema Information
# Schema version: 23
#
# Table name: locations
#
#  id                 :integer(11)   not null, primary key
#  agency_id          :integer(11)   
#  name               :string(255)   
#  name2              :string(255)   
#  is_hq              :boolean(1)    
#  is_provider        :boolean(1)    
#  tollfree           :string(20)    
#  tollfree_ext       :string(10)    
#  phone              :string(20)    
#  phone_ext          :string(10)    
#  tty                :string(20)    
#  tty_ext            :string(10)    
#  fax                :string(20)    
#  email              :string(255)   
#  hours_of_operation :string(255)   
#  logistics          :string(255)   
#  updated_at         :datetime      
#  legacy_code        :string(10)    
#  legacy_subcode     :string(10)    
#  fmp2_code          :string(10)    
#

class Location < ActiveRecord::Base  
  belongs_to :agency
  has_many :addresses
  has_one :restriction
  
  has_one :mailing_address, :class_name => 'Address', 
            :conditions => "address_type = 'mailing'"
  has_one :dropin_address, :class_name => 'Address', 
            :conditions => "address_type =  'dropin'"
end
