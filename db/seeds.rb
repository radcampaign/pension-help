# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

if Rails.env == 'staging'
  u = User.new(login: 'qa_test', email: 'alicja@freeportmetrics.com', password: 'freeport2014', password_confirmation: 'freeport2014')
  u.roles.push(Role.where(role_name: "ADMIN"))
  u.save!
end

