# == Schema Information
#
# Table name: plan_categories
#
#  id       :integer          not null, primary key
#  name     :string(255)
#  position :integer
#

class PlanCategory < ActiveRecord::Base
end
