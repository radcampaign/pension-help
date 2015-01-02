# == Schema Information
#
# Table name: roles
#
#  id          :integer          not null, primary key
#  role_name   :string(255)
#  description :string(255)
#

class Role < ActiveRecord::Base
  has_and_belongs_to_many :users
end
