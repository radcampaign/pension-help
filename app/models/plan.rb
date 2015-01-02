# == Schema Information
#
# Table name: plans
#
#  id                    :integer          not null, primary key
#  agency_id             :integer
#  name                  :string(255)
#  name2                 :string(255)
#  description           :text
#  comments              :text
#  start_date            :date
#  end_date              :date
#  covered_employees     :text
#  plan_type1            :string(255)
#  plan_type2            :string(255)
#  plan_type3            :string(255)
#  url                   :string(255)
#  url_title             :string(255)
#  admin_url             :string(255)
#  admin_url_title       :string(255)
#  tpa_url               :string(255)
#  tpa_url_title         :string(255)
#  spd_url               :string(255)
#  spd_url_title         :string(255)
#  govt_employee_type    :string(255)
#  fmp2_code             :string(255)
#  legacy_category       :string(255)
#  legacy_status         :string(255)
#  updated_at            :datetime
#  updated_by            :string(255)
#  email                 :string(255)
#  position              :integer
#  pha_contact_name      :string(255)
#  pha_contact_title     :string(255)
#  pha_contact_phone     :string(20)
#  pha_contact_email     :string(255)
#  is_active             :boolean          default(TRUE)
#  previous_gov_employee :string(255)
#  plan_category_id      :integer
#

require 'restrictions_updater'

class Plan < ActiveRecord::Base
  include RestrictionsUpdater
  belongs_to :agency
  belongs_to :plan_category
  has_one :publication
  has_many :restrictions, :dependent => :destroy
  has_many :plan_catch_all_employees, ->{order('position asc')}, :dependent => :destroy
  has_many :employee_types, :through => :plan_catch_all_employees
  has_many :location_plan_relationships, :dependent => :destroy
  has_many :serving_locations, :through => :location_plan_relationships, :source => :location
  before_save :update_employee_types, :update_serving_locations

  validates_presence_of     :name

  composed_of :pha_contact, :class_name => 'PhaContact',
    :mapping => [
      [:pha_contact_name, :name],
      [:pha_contact_title, :title],
      [:pha_contact_phone, :phone],
      [:pha_contact_email, :email],
    ]

  attr_accessor :new_locations, :location_hq

  def catchall_employees
    self.employee_types.collect{|et| et.name}.join(', ')
  end

  def catchall_employees=(value)
    @catchall_employees=value
  end

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

  def update_employee_types
    return if @catchall_employees.nil?
    @catchall_employees.split(', ').each do |e|
      # MySQL is case insensitive, so we grab all matching employees and do the comparisons on our own
      unless et=EmployeeType.all.where(['name = ?', e]).select{|emp| emp.name==e}.first
        et=EmployeeType.new
        et.name = e
        et.save!
      end
      pcae=PlanCatchAllEmployee.new(:employee_type_id => et.id, :plan_id => self.id)
      self.plan_catch_all_employees << pcae unless self.employee_types.include?(et)
    end
    plan_catch_all_employees.select{|item| !@catchall_employees.split(', ').include?( item.employee_type.name )}.each{|pcae| pcae.destroy}
  end

  # update list of locations that serve this plan
  def update_serving_locations
    unless new_locations.nil?
      self.location_plan_relationships.each do |relationship|
        relationship.update_attribute(:is_hq, relationship.location_id == location_hq)
        relationship.destroy unless new_locations.include?(relationship.location_id)
        new_locations.delete(relationship.location_id)
      end
      new_locations.each do |loc_id|
        self.location_plan_relationships.create(:location_id => loc_id, :is_hq=> loc_id == location_hq) unless loc_id.blank?
      end
      self.new_locations = nil
    end
  end

  def best_location(counseling)
    # out of state should find hq
    if (counseling.home_state_abbrev == serving_locations.first.dropin_address.state_abbrev rescue nil) # in home state
      closest_serving_location(counseling.home_zip)
    else  #out of state
      hq_serving_location
    end
  end

  def hq_serving_location
    potential_matches = self.location_plan_relationships
    return nil if potential_matches.empty?
    #use hq if available otherwise just return first match (admin probably forgot to assign a HQ for this plan)
    potential_matches.select{|rel| rel.is_hq}.first.location rescue potential_matches.first.location
  end

  def closest_serving_location(zip)
    serving_locations.map{|loc| loc.dropin_address}.sort_by{|a| a.distance_from(zip)}.first.location
  end

end
