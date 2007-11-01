# == Schema Information
# Schema version: 11
#
# Table name: addresses
#
#  id              :integer(11)   not null, primary key
#  line1           :string(255)   
#  line2           :string(255)   
#  city            :string(255)   
#  state_abbrev    :string(255)   
#  zip             :string(255)   
#  agency_id       :integer(11)   
#  address_type_id :integer(11)   
#

class Address < ActiveRecord::Base
  MAILING_ADDRESS = 1
  DROPIN_ADDRESS = 2
end
