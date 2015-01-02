#!/usr/bin/env ../script/runner
Zip.find(:all).each do |zip|
  c=Counseling.create({:zipcode=>zip.zipcode})
  puts '"' + zip.zipcode + '",' + c.aoa_coverage.first.name unless c.aoa_coverage.blank? rescue nil
end
