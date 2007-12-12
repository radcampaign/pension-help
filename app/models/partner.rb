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
                          :line1, 
                          :city, 
                          :state_abbrev, 
                          :zip_code, 
                          :phone, 
                          :email
  
end
