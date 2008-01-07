# == Schema Information
# Schema version: 35
#
# Table name: partners
#
#  id                             :integer(11)   not null, primary key
#  first_name                     :string(80)    
#  last_name                      :string(80)    
#  middle_initial                 :string(2)     
#  company                        :string(255)   
#  line_1                         :string(255)   
#  line_2                         :string(255)   
#  city                           :string(50)    
#  state_abbrev                   :string(2)     
#  zip_code                       :string(10)    
#  phone                          :string(20)    
#  fax                            :string(20)    
#  email                          :string(255)   
#  url                            :string(255)   
#  reduced_fee_desc               :string(255)   
#  contingency_fee_desc           :string(255)   
#  consultation_fee               :string(255)   
#  hourly_rate                    :integer(11)   
#  bar_admissions                 :string(255)   
#  aaa_member                     :boolean(1)    
#  willing_to_provide             :boolean(1)    
#  willing_to_answer              :boolean(1)    
#  wont_charge_fees               :boolean(1)    
#  info_geo                       :string(255)   
#  info_industries                :string(255)   
#  profession_other               :string(255)   
#  sponsor_type_other             :string(255)   
#  plan_type_other                :string(255)   
#  claim_type_other               :string(255)   
#  npln_additional_area_other     :string(255)   
#  npln_participation_level_other :string(255)   
#  pal_additional_area_other      :string(255)   
#  pal_participation_level_other  :string(255)   
#  help_additional_area_other     :string(255)   
#  certifications                 :text          
#  affiliations                   :text          
#  other_info                     :text          
#  wants_npln                     :boolean(1)    
#  wants_pal                      :boolean(1)    
#  wants_help                     :boolean(1)    
#  wants_search                   :boolean(1)    
#

class Partner < ActiveRecord::Base
  has_and_belongs_to_many :professions
  has_and_belongs_to_many :sponsor_types
  has_and_belongs_to_many :plan_types
  has_and_belongs_to_many :referral_fees
  has_and_belongs_to_many :claim_types, :join_table => "partners_claim_types"
  has_and_belongs_to_many :npln_additional_areas, 
                          :join_table => "partners_npln_additional_areas"
  has_and_belongs_to_many :npln_participation_levels, 
                          :join_table => "partners_npln_participation_levels"
  has_and_belongs_to_many :pal_additional_areas, 
                          :join_table => "partners_pal_additional_areas"
  has_and_belongs_to_many :pal_participation_levels, 
                          :join_table => "partners_pal_participation_levels"
  has_and_belongs_to_many :search_plan_types
  has_and_belongs_to_many :help_additional_areas, 
                          :join_table => "partners_help_additional_areas"
                          

  validates_presence_of   :first_name, 
                          :last_name, 
                          :line_1, 
                          :city, 
                          :state_abbrev, 
                          :zip_code, 
                          :phone, 
                          :email
                          
  validates_numericality_of :hourly_rate,
                            :if => Proc.new {|p| !p.new_record? and (p.wants_npln or p.wants_pal) }
  
end
