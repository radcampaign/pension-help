# == Schema Information
# Schema version: 8
#
# Table name: professions
#
#  id       :integer(11)   not null, primary key
#  name     :string(255)   
#  position :integer(11)   
#

class Profession < ActiveRecord::Base
end
