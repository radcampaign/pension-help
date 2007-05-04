# == Schema Information
# Schema version: 8
#
# Table name: search_nets
#
#  id               :integer(11)   not null, primary key
#  contact_id       :integer(11)   
#  wont_charge_fees :boolean(1)    
#  info_plans       :string(255)   
#  info_geo         :string(255)   
#  info_industries  :string(255)   
#  info_referrals   :string(255)   
#

class SearchNet < ActiveRecord::Base
  belongs_to :contact
end
