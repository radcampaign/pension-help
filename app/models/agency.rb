# == Schema Information
# Schema version: 19
#
# Table name: agencies
#
#  id               :integer(11)   not null, primary key
#  name             :string(255)   
#  name2            :string(255)   
#  data_source      :string(255)   
#  is_active        :boolean(1)    
#  url              :string(255)   
#  url_title        :string(255)   
#  legacy_code      :string(255)   
#  legacy_subcode   :string(255)   
#  created_at       :datetime      
#  updated_at       :datetime      
#  updated_by       :string(255)   
#  plan_category_id :integer(11)   
#

class Agency < ActiveRecord::Base
  has_many :locations
  has_many :plans

  has_enumerated :plan_category
  
end
