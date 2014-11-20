# == Schema Information
#
# Table name: federal_plans
#
#  id                 :integer          not null, primary key
#  name               :string(255)
#  position           :integer
#  parent_id          :integer
#  associated_plan_id :integer
#

class FederalPlan < ActiveRecord::Base
end
