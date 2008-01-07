# == Schema Information
# Schema version: 35
#
# Table name: zips
#
#  zipcode      :string(255)   primary key
#  state_abbrev :string(255)   
#  county_id    :integer(11)   
#

class Zip < ActiveRecord::Base
  self.primary_key = 'zipcode'
end
