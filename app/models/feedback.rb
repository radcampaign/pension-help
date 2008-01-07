# == Schema Information
# Schema version: 35
#
# Table name: feedbacks
#
#  id           :integer(11)   not null, primary key
#  name         :string(255)   
#  email        :string(255)   
#  phone        :string(255)   
#  availability :string(255)   
#  category     :string(255)   
#  feedback     :text          
#  is_resolved  :boolean(1)    
#  created_at   :datetime      
#  updated_at   :datetime      
#

class Feedback < ActiveRecord::Base
end
