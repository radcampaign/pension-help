# == Schema Information
# Schema version: 41
#
# Table name: states
#
#  abbrev :string(2)     not null, primary key
#  name   :string(50)    
#

class State < ActiveRecord::Base
  self.primary_key = 'abbrev'
  has_many :counties, :foreign_key => 'state_abbrev'
  
  def State.find_by_state_abbrevs(abbrevs)
    result = Array.new
    args = Array.new
    cond = ''
    unless abbrevs.nil?
      abbrevs.each_with_index do |abbrev,index|
        if index == 0
          cond += ' abbrev = ?'
        else
          cond += ' OR abbrev = ?'
        end
        args << abbrev
      end
      result = State.find(:all, :conditions => [cond, args].flatten)
    end
    result
  end
  
  def State.agency_matches(state_abbrev)
    sql = <<-SQL
        select distinct a.*
        from agencies a
        join plans p on p.agency_id = a.id
        join restrictions r on r.plan_id = p.id
        join restrictions_states rs on rs.restriction_id = r.id
        left join restrictions_counties rc on rc.restriction_id = r.id
        left join restrictions_cities rci on rci.restriction_id = r.id
        where rc.county_id is null
        and rci.city_id is null
        and a.agency_category_id = 3
        and rs.state_abbrev = ?
        and a.use_for_counseling = 1 and a.is_active = 1 and p.is_active = 1
        SQL
    Agency.find_by_sql([sql, state_abbrev])
  end
  
  def catchall_employees
    PlanCatchAllEmployee.find(:all, :conditions => ['plan_id in (?)', State.agency_matches(self.abbrev).collect{|agency| agency.plans}.flatten], :order => :position)
    # State.agency_matches(self.abbrev).collect{|agency| agency.plans}.flatten.collect{|plan| plan.plan_catch_all_employees}.flatten
  end
  
end
