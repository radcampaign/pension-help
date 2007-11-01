class AddAgencyTypesAndCategories < ActiveRecord::Migration
  class AgencyType < ActiveRecord::Base
  end
  class AgencyCategory < ActiveRecord::Base
  end
  def self.up
    create_table :agency_types do |t|
      t.column :name, :string
      t.column :position, :integer
    end
    create_table :agency_categories do |t|
      t.column :name, :string
      t.column :position, :integer
    end
    %w{
      Government 
      AoA 
      NSP+ 
      DSP 
      Other}.each_with_index {|c, i| AgencyCategory.create(:id => i+1, :name => c, :position => i+1)}
    %w{
      DOL
      IRS
      PBGC
      OPM
      TSP
      DFAS
      RRB
      State
      Local
      EmpType
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
    }.each_with_index {|c, i| AgencyType.create(:id => i+1, :name => c, :position => i+1)}
  end

  def self.down
    drop_table :agency_types
    drop_table :agency_categories
  end
  
end
