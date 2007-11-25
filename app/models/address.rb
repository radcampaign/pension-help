# == Schema Information
# Schema version: 23
#
# Table name: addresses
#
#  id             :integer(11)   not null, primary key
#  location_id    :integer(11)   
#  line1          :string(255)   
#  line2          :string(255)   
#  city           :string(64)    
#  state_abbrev   :string(255)   
#  zip            :string(255)   
#  address_type   :string(255)   
#  legacy_code    :string(10)    
#  legacy_subcode :string(10)    
#  fmp2_code      :string(10)    
#

class Address < ActiveRecord::Base
  belongs_to :location
  belongs_to :state, :foreign_key => "state_abbrev"
end
