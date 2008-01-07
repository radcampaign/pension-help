# == Schema Information
# Schema version: 35
#
# Table name: publications
#
#  id           :integer(11)   not null, primary key
#  agency_id    :integer(11)   
#  tollfree     :string(20)    
#  tollfree_ext :string(10)    
#  phone        :string(20)    
#  phone_ext    :string(10)    
#  tty          :string(20)    
#  tty_ext      :string(10)    
#  fax          :string(20)    
#  email        :string(255)   
#  url          :string(255)   
#  url_title    :string(255)   
#  legacy_code  :string(10)    
#  fmp2_code    :string(10)    
#

class Publication < ActiveRecord::Base
  belongs_to :agency
end
