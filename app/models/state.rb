# == Schema Information
# Schema version: 41
#
# Table name: states
#
#  abbrev :string(2)     not null, primary key
#  name   :string(50)    
#

class State < ActiveRecord::Base
  self.primary_key = 'abbrev'
  has_many :counties, :foreign_key => 'state_abbrev'
end
