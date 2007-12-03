# == Schema Information
# Schema version: 17
#
# Table name: counties
#
#  id           :integer(11)   not null, primary key
#  name         :string(255)   
#  fips_code    :string(255)   
#  state_abbrev :string(255)   
#

class County < ActiveRecord::Base
  belongs_to :state
  has_many :cities
  has_many :zips
end
