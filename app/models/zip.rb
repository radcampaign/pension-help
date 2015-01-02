# == Schema Information
#
# Table name: zips
#
#  zipcode      :string(255)      default(""), not null, primary key
#  state_abbrev :string(255)
#  county_id    :integer
#

class Zip < ActiveRecord::Base
  self.primary_key = 'zipcode'

end
