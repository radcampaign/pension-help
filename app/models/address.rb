# == Schema Information
# Schema version: 20
#
# Table name: addresses
#
#  id             :integer(11)   not null, primary key
#  line1          :string(255)   
#  line2          :string(255)   
#  city           :string(64)    
#  state_abbrev   :string(255)   
#  zip            :string(255)   
#  address_type   :string(255)   
#  location_id    :integer(11)   
#  legacy_code    :string(255)   
#  legacy_subcode :string(255)   
#

class Address < ActiveRecord::Base
  belongs_to :location
  belongs_to :state, :foreign_key => "state_abbrev"
end
