class Location < ActiveRecord::Base
  #include restrictions update code which exactly same for Locations and Plans
  include RestrictionsUpdater

  belongs_to :agency
  has_many :addresses, :dependent => :destroy
  has_many :restrictions, :dependent => :destroy
  has_many :location_plan_relationships, :dependent => :destroy
  has_many :plans_served, :through => :location_plan_relationships, :source => :plan
  
  has_one :mailing_address, :class_name => 'Address', 
            :conditions => "address_type = 'mailing'"
  has_one :dropin_address, :class_name => 'Address', 
            :conditions => "address_type =  'dropin'"
  before_save :update_plans_served
  
  validates_presence_of     :name
  
  composed_of :pha_contact, :class_name => PhaContact,
    :mapping => [
      [:pha_contact_name, :name],
      [:pha_contact_title, :title],
      [:pha_contact_phone, :phone],
      [:pha_contact_email, :email],
    ]

  attr_accessor :visible_in_view, :new_plans, :plan_hq

  def age_restrictions?
    sql = <<-SQL
      select
        l.id
      from
        locations l join restrictions r on r.location_id = l.id
      where
        l.id = ?
        and r.minimum_age is not null
      SQL

    Location.find_by_sql([sql, id]).size > 0
  end

  def income_restrictions?
    sql = <<-SQL
      select
        l.id
      from
        locations l join restrictions r on r.location_id = l.id
      where
        l.id = ?
        and r.max_poverty is not null 
      SQL

    Location.find_by_sql([sql, id]).size > 0
  end

  def and_restrictions?
    restrictions.select{|r| r.age_and_income}.size > 0 unless restrictions.empty?
  end

  #returns "NSP","DSP", or ""
  def get_provider_type
    return '' unless is_provider?
    unless restrictions.empty?
      restrictions.select{|r| r.minimum_age.nil? and r.max_poverty.nil?}.empty? ? 'DSP' : 'NSP'
      # (restriction.minimum_age.nil? && restriction.max_poverty.nil?) ? 'NSP' : 'DSP'
    else
      'NSP'
    end
  end

  # update list of plans that served by this location
  def update_plans_served
    unless new_plans.nil?
      self.location_plan_relationships.each do |relationship|
        relationship.is_hq = plan_hq.include?(relationship.location_id)
        relationship.destroy unless new_plans.include?(relationship.plan_id)
        new_plans.delete(relationship.plan_id)
      end
      new_plans.each do |plan_id|
        self.location_plan_relationships.create(:plan_id => plan_id, :is_hq=> plan_hq.include?(plan_id)) unless plan_id.blank?
      end
      reload unless id.nil?
      self.new_plans = nil
    end
  end
  
end
