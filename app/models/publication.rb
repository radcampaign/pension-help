# == Schema Information
# Schema version: 20
#
# Table name: publications
#
#  id           :integer(11)   not null, primary key
#  name         :string(255)   
#  plan_id      :integer(11)   
#  phone        :string(20)    
#  phone_ext    :string(10)    
#  tollfree     :string(20)    
#  tollfree_ext :string(10)    
#  fax          :string(20)    
#  tty          :string(20)    
#  tty_ext      :string(10)    
#  email        :string(255)   
#  url          :string(255)   
#  url_title    :string(255)   
#  created_at   :datetime      
#  updated_at   :datetime      
#  legacy_code  :string(255)   
#

class Publication < ActiveRecord::Base
  belongs_to :plan
end
