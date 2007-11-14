# == Schema Information
# Schema version: 16
#
# Table name: agencies
#
#  id             :integer(11)   not null, primary key
#  name           :string(255)   
#  name2          :string(255)   
#  data_source    :string(255)   
#  is_active      :boolean(1)    
#  url            :string(255)   
#  url_title      :string(255)   
#  legacy_code    :string(255)   
#  legacy_subcode :string(255)   
#  created_at     :datetime      
#  updated_at     :datetime      
#  updated_by     :string(255)   
#

class Agency < ActiveRecord::Base
  has_one :mailing_address, :class_name => 'Address', 
            :conditions => "address_type = 'mailing'"
  has_one :dropin_address, :class_name => 'Address', 
            :conditions => "address_type =  'dropin'"
  
end
