#!/usr/bin/env /Users/dan/GradientBlue/eclipse/pha/script/runner
university_agencies=Agency.find(:all).select{|agency| aname=agency.name.downcase;
    (aname.include?("university") and aname.include?("system")) or
    (aname.include?("higher education") and aname.include?("system")) or
    aname.include?("idaho state board of education") or
    aname.include?("indiana university (iu) human resources service") or
    aname.include?("kansas board of regents") or
    aname.include?("nebraska state college system") or
    aname.include?("north dakota state board of higher education") or
    aname.include?("the texas higher education coordinating board") or
    aname.include?("massachusetts department of higher education") or
    aname.include?("university of alaska") or
    aname.include?("university of minnesota") or
    aname.include?("university of missouri") or
    aname.include?("university of nebraska") or
    aname.include?("university of oklahoma") or
    aname.include?("university of rhode island") or
    aname.include?("washington state university")}
    
university_agencies.each do |agency| 
  agency.locations.each do |loc| 
    if !loc.is_hq
      puts "deactivating " + loc.name
      loc.is_active=false
      loc.save!
    end
  end
end