#!/usr/bin/env ../script/runner
results = {}
puts "NUMBER = " + Counseling.find(:all).size.to_s
puts "COUNSELING = " + Counseling.find(:all).type.to_s
Counseling.find(:all).each do |c|
  month=c.created_at.year.to_s + ("%02d" % c.created_at.month) rescue "xxx"
  results[month]!={}
  results[month]["aoa"] != {}
  results[month]["aoa"] = results[month]["aoa"] + 1 unless c.aoa_coverage.blank?
end
puts results
