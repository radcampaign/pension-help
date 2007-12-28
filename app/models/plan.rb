# == Schema Information
# Schema version: 33
#
# Table name: plans
#
#  id                 :integer(11)   not null, primary key
#  agency_id          :integer(11)   
#  name               :string(255)   
#  name2              :string(255)   
#  description        :text          
#  comments           :text          
#  start_date         :date          
#  end_date           :date          
#  covered_employees  :text          
#  catchall_employees :text          
#  plan_type1         :string(255)   
#  plan_type2         :string(255)   
#  plan_type3         :string(255)   
#  url                :string(255)   
#  url_title          :string(255)   
#  admin_url          :string(255)   
#  admin_url_title    :string(255)   
#  tpa_url            :string(255)   
#  tpa_url_title      :string(255)   
#  spd_url            :string(255)   
#  spd_url_title      :string(255)   
#  govt_employee_type :string(255)   
#  fmp2_code          :string(255)   
#  legacy_category    :string(255)   
#  legacy_status      :string(255)   
#  updated_at         :datetime      
#  updated_by         :string(255)   
#  email              :string(255)   
#

class Plan < ActiveRecord::Base
  belongs_to :agency
  has_one :publication
  has_one :restriction
  
  def employee_list
    return nil if catchall_employees.blank?
    catchall_employees.split(', ').collect{|e| [e, id]}
  end
  
  def start_date_formatted
     start_date.strftime '%m/%d/%Y' if start_date
  end
  
  def start_date_formatted=(value)
     self.start_date = Date.parse(value) if !value.blank?
  end

  def end_date_formatted
     end_date.strftime '%m/%d/%Y' if end_date
  end
  
  def end_date_formatted=(value)
     self.end_date = Date.parse(value) if !value.blank?
  end

end
