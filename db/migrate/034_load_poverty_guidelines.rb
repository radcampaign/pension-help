class LoadPovertyGuidelines < ActiveRecord::Migration
  class PovertyLevel < ActiveRecord::Base
  
  end
  def self.up
    PovertyLevel.create(:year => 2007, :number_in_household => 1, :geographic => 'US', :fpl => 10210 )
    PovertyLevel.create(:year => 2007, :number_in_household => 1, :geographic => 'AK', :fpl => 12770 )
    PovertyLevel.create(:year => 2007, :number_in_household => 1, :geographic => 'HI', :fpl => 11750 )
    PovertyLevel.create(:year => 2007, :number_in_household => 2, :geographic => 'US', :fpl => 13690 )
    PovertyLevel.create(:year => 2007, :number_in_household => 2, :geographic => 'AK', :fpl => 17120 )
    PovertyLevel.create(:year => 2007, :number_in_household => 2, :geographic => 'HI', :fpl => 15750 )
    PovertyLevel.create(:year => 2007, :number_in_household => 3, :geographic => 'US', :fpl => 17170 )
    PovertyLevel.create(:year => 2007, :number_in_household => 3, :geographic => 'AK', :fpl => 21470 )
    PovertyLevel.create(:year => 2007, :number_in_household => 3, :geographic => 'HI', :fpl => 19750 )
    PovertyLevel.create(:year => 2007, :number_in_household => 4, :geographic => 'US', :fpl => 20650 )
    PovertyLevel.create(:year => 2007, :number_in_household => 4, :geographic => 'AK', :fpl => 25820 )
    PovertyLevel.create(:year => 2007, :number_in_household => 4, :geographic => 'HI', :fpl => 23750 )    
    PovertyLevel.create(:year => 2007, :number_in_household => 5, :geographic => 'US', :fpl => 24130 )
    PovertyLevel.create(:year => 2007, :number_in_household => 5, :geographic => 'AK', :fpl => 30170 )
    PovertyLevel.create(:year => 2007, :number_in_household => 5, :geographic => 'HI', :fpl => 27750 )
    PovertyLevel.create(:year => 2007, :number_in_household => 6, :geographic => 'US', :fpl => 27610 )
    PovertyLevel.create(:year => 2007, :number_in_household => 6, :geographic => 'AK', :fpl => 34520 )
    PovertyLevel.create(:year => 2007, :number_in_household => 6, :geographic => 'HI', :fpl => 31750 )
    PovertyLevel.create(:year => 2007, :number_in_household => 7, :geographic => 'US', :fpl => 31090 )
    PovertyLevel.create(:year => 2007, :number_in_household => 7, :geographic => 'AK', :fpl => 38870 )
    PovertyLevel.create(:year => 2007, :number_in_household => 7, :geographic => 'HI', :fpl => 35750 )
    PovertyLevel.create(:year => 2007, :number_in_household => 8, :geographic => 'US', :fpl => 34570 )
    PovertyLevel.create(:year => 2007, :number_in_household => 8, :geographic => 'AK', :fpl => 43220 )
    PovertyLevel.create(:year => 2007, :number_in_household => 8, :geographic => 'HI', :fpl => 39750 )
  end

  def self.down
  end
end
