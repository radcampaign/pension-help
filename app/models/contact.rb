# == Schema Information
# Schema version: 8
#
# Table name: contacts
#
#  id               :integer(11)   not null, primary key
#  first_name       :string(80)    
#  last_name        :string(80)    
#  middle_initial   :string(2)     
#  company          :string(255)   
#  line_1           :string(255)   
#  line_2           :string(255)   
#  city             :string(50)    
#  state_abbrev     :string(2)     
#  zip_code         :string(10)    
#  phone            :string(20)    
#  fax              :string(20)    
#  email            :string(255)   
#  url              :string(255)   
#  profession_id    :integer(11)   
#  profession_other :string(255)   
#  affiliations     :string(255)   
#  wants_npln       :boolean(1)    
#  wants_aaa        :boolean(1)    
#

class Contact < ActiveRecord::Base
  has_one :help_net, :dependent => :destroy
  has_one :search_net, :dependent => :destroy
  belongs_to :profession, :dependent => :destroy
end
