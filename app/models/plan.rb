# == Schema Information
# Schema version: 19
#
# Table name: plans
#
#  id                  :integer(11)   not null, primary key
#  name                :string(255)   
#  name2               :string(255)   
#  agency_id           :integer(11)   
#  start_date          :date          
#  end_date            :date          
#  covered_employees   :text          
#  catchall_employees  :text          
#  description         :text          
#  service_description :text          
#  comments            :text          
#  status              :string(255)   
#  govt_employee_type  :string(255)   
#  special_district    :string(255)   
#  plan_type1          :string(255)   
#  plan_type2          :string(255)   
#  plan_type3          :string(255)   
#  url                 :string(255)   
#  url_title           :string(255)   
#  admin_url           :string(255)   
#  admin_url_title     :string(255)   
#  tpa_url             :string(255)   
#  tpa_url_title       :string(255)   
#  spd_url             :string(255)   
#  spd_url_title       :string(255)   
#  created_at          :datetime      
#  updated_at          :datetime      
#  updated_by          :string(255)   
#  age_threshold       :decimal(5, 2) 
#  income_threshold    :decimal(9, 2) 
#

class Plan < ActiveRecord::Base
  belongs_to :agency
  has_and_belongs_to_many :states, :join_table => "plans_states", :association_foreign_key => "state_abbrev"
  has_and_belongs_to_many :zips, :join_table => "plans_zips", :association_foreign_key => "zipcode"
  has_and_belongs_to_many :cities, :join_table => "plans_cities"
  has_and_belongs_to_many :counties, :join_table => "plans_counties"
end
