# == Schema Information
# Schema version: 17
#
# Table name: locations
#
#  id                 :integer(11)   not null, primary key
#  name               :string(255)   
#  is_hq              :boolean(1)    
#  agency             :integer(11)   
#  phone              :string(20)    
#  phone_ext          :string(10)    
#  tollfree           :string(20)    
#  tollfree_ext       :string(10)    
#  fax                :string(20)    
#  tty                :string(20)    
#  tty_ext            :string(10)    
#  email              :string(255)   
#  hours_of_operation :string(255)   
#  logistics          :string(255)   
#  legacy_subcode     :string(10)    
#  created_at         :datetime      
#  updated_at         :datetime      
#  updated_by         :string(255)   
#

class Location < ActiveRecord::Base
  belongs_to :agency
  has_and_belongs_to_many :states, :join_table => "locations_states", :association_foreign_key => "state_abbrev"
  has_and_belongs_to_many :counties, :join_table => "locations_counties"
end
