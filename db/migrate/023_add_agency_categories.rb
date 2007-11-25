class AddAgencyCategories < ActiveRecord::Migration
  class AgencyCategory < ActiveRecord::Base
  end
  class ResultType < ActiveRecord::Base
  end
  def self.up
    ['Government',
      'Service Provider',
      'State/Local Plans',
      'Other'
    ].each_with_index {|c, i| AgencyCategory.create(:id => i+1, :name => c, :position => i+1)}
    %w{ 
      AoA 
      DOL
      IRS
      PBGC
      OPM
      TSP
      DFAS
      RRB
      NARFE
      EXPOSE
      SSA
      AFSCME
      RSO
      NRAO
      AFRSB
      USMCP
      OHSPSC
      OPMOSB
      PHSRC
      Other
    }.each_with_index {|c, i| ResultType.create(:id => i+1, :name => c, :position => i+1)}
    
  end

  def self.down
  end
end
