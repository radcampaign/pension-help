# == Schema Information
# Schema version: 33
#
# Table name: cities
#
#  id           :integer(11)   not null, primary key
#  name         :string(255)   
#  county_id    :integer(11)   
#  state_abbrev :string(255)   
#

class City < ActiveRecord::Base
  belongs_to :county
end
