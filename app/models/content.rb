# == Schema Information
# Schema version: 33
#
# Table name: contents
#
#  id         :integer(11)   not null, primary key
#  url        :string(255)   
#  title      :string(255)   
#  content    :text          
#  created_at :string(255)   
#  updated_at :datetime      
#  updated_by :string(255)   
#

class Content < ActiveRecord::Base
end
