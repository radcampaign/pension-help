# == Schema Information
#
# Table name: location_plan_relationships
#
#  id          :integer          not null, primary key
#  location_id :integer
#  plan_id     :integer
#  is_hq       :boolean
#

class LocationPlanRelationship < ActiveRecord::Base
  belongs_to :location
  belongs_to :plan
end
