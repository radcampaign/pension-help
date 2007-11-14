class AddPlanCategories < ActiveRecord::Migration
  class PlanCategory < ActiveRecord::Base
  end
  def self.up
    create_table :agency_types, :force => true do |t| end
    drop_table :agency_types
    create_table :agency_categories, :force => true do |t| end
    drop_table :agency_categories
    
    create_table :plan_categories do |t|
      t.column :name, :string
      t.column :position, :integer
    end
    %w{
      Government 
      AoA 
      NSP+ 
      DSP 
      Other
      DOL
      IRS
      PBGC
      OPM
      TSP
      DFAS
      RRB
      State
      Local
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
    }.each_with_index {|c, i| PlanCategory.create(:id => i+1, :name => c, :position => i+1)}
  end

  def self.down
    begin
      drop_table :plan_categories
    rescue 
    end
  end
  
end
