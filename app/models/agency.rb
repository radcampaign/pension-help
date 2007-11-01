# == Schema Information
# Schema version: 11
#
# Table name: agencies
#
#  id                   :integer(11)   not null, primary key
#  name                 :string(255)   
#  name2                :string(255)   
#  parent_id            :integer(11)   
#  description          :text          
#  service_description  :text          
#  phone                :string(255)   
#  tollfree             :string(255)   
#  fax                  :string(255)   
#  tty                  :string(255)   
#  url                  :string(255)   
#  url2                 :string(255)   
#  email                :string(255)   
#  hours_of_operation   :string(255)   
#  logistics            :string(255)   
#  comments             :text          
#  data_source          :string(255)   
#  is_active            :boolean(1)    
#  legacy_code          :string(255)   
#  legacy_subcode       :string(255)   
#  has_restrictions     :boolean(1)    
#  has_geo_restrictions :boolean(1)    
#  agency_category_id   :integer(11)   
#  agency_type_id       :integer(11)   
#  created_at           :datetime      
#  updated_at           :datetime      
#  updated_by           :string(255)   
#

class Agency < ActiveRecord::Base
  has_one :mailing_address, :class_name => 'Address', 
            :conditions => "address_type_id = #{Address::MAILING_ADDRESS}"
  has_one :dropin_address, :class_name => 'Address', 
            :conditions => "address_type_id =  #{Address::DROPIN_ADDRESS}"
  has_enumerated :agency_type
  has_enumerated :agency_category
end
