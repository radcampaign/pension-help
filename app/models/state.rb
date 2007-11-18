# == Schema Information
# Schema version: 8
#
# Table name: states
#
#  abbrev :string(2)     default(""), not null
#  name   :string(10)    
#

class State < ActiveRecord::Base
  self.primary_key = 'abbrev'
  has_many :counties, :foreign_key => 'state_abbrev'
end
