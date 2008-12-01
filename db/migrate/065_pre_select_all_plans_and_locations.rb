class PreSelectAllPlansAndLocations < ActiveRecord::Migration
  def self.up
    Agency.find(:all, :conditions => ['agencies.is_active = ?',1], :include => [:locations, :plans]).each do |agency|
      agency.locations.each do |loc|
        if loc.is_active
          agency.plans.each do |p|
            if p.is_active
              rel=LocationPlanRelationship.new
              rel.location=loc
              rel.plan=p
              rel.is_hq=loc.is_hq
              rel.save!
            end
          end
        end
      end
    end
  end

  def self.down
    LocationPlanRelationship.find(:all).destroy
  end
end
