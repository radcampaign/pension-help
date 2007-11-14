# == Schema Information
# Schema version: 17
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
#  url          :string(255)   
#  url_title    :string(255)   
#  created_at   :datetime      
#  updated_at   :datetime      
#

class Publication < ActiveRecord::Base
end
