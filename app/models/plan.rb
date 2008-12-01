class Plan < ActiveRecord::Base
  include RestrictionsUpdater
  belongs_to :agency
  has_one :publication, :dependent => :destroy
  has_many :restrictions, :dependent => :destroy
  has_many :plan_catch_all_employees, :dependent => :destroy, :order => :position
  has_many :employee_types, :through => :plan_catch_all_employees
  has_many :location_plan_relationships, :dependent => :destroy
  has_many :serving_locations, :through => :location_plan_relationships, :source => :location
  before_save :update_employee_types, :update_serving_locations
  
  validates_presence_of     :name
  
  composed_of :pha_contact, :class_name => PhaContact,
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
    @catchall_employees.split(', ').each do |e|
      # MySQL is case insensitive, so we grab all matching employees and do the comparisons on our own
      unless et=EmployeeType.find(:all, :conditions => ['name = ?', e]).select{|emp| emp.name==e}.first
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
        relationship.is_hq = relationship.location_id == location_hq
        relationship.destroy unless new_locations.include?(relationship.location_id)
        new_locations.delete(relationship.location_id)
      end
      new_locations.each do |loc_id|
        self.location_plan_relationships.create(:location_id => loc_id, :is_hq=> loc_id == location_hq) unless loc_id.blank?
      end
      reload
      self.new_locations = nil
    end
  end
  
end
