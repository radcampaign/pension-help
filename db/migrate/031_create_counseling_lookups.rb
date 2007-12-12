class CreateCounselingLookups < ActiveRecord::Migration
  class EmployerType < ActiveRecord::Base
  end
  class FederalPlan < ActiveRecord::Base
  end
  class MilitaryService < ActiveRecord::Base
  end
  class MilitaryBranch < ActiveRecord::Base
  end
  class MilitaryEmployer < ActiveRecord::Base
  end
  class PensionEarner < ActiveRecord::Base
  end
  
  def self.up
    %w{
      employer_types
      federal_plans
      military_services
      military_branches
      military_employers
      pension_earners
    }.each do |tbl|
      create_table tbl do |t|
        t.column :name, :string
        t.column :position, :integer
      end
    end
    create_table :poverty_levels do |t|
      t.column :year, :integer
      t.column :number_in_household, :integer
      t.column :geographic, :string
      t.column :fpl, :decimal, :precision => 8, :scale => 2
    end
    [ 'Company or nonprofit',
  	  'Railroad',
  	  'Religious institution',
      "Federal agency or office",
      "Military",
      "State agency or office",
      "County agency or office",
      "City or other local government agency or office",
    	'I don\'t know'
    ].each_with_index {|c, i| EmployerType.create(:id => i+1, :name => c, :position => i+1)}
    
    [ "Federal Employee Retirement System (FERS)",
      "Civil Service Retirement System (CSRS)",
      "Thrift Savings Plan (TSP)",
      "Other",
      "I don’t know"
    ].each_with_index {|c, i| FederalPlan.create(:id => i+1, :name => c, :position => i+1)}
    
    ["Uniformed services Active duty",
     "Armed services Ready Reserve",
     "Armed services National Guard",
     "Civilian military employment",
     "I don’t know"
    ].each_with_index {|c, i| MilitaryService.create(:id => i+1, :name => c, :position => i+1)}

    ["Army",
     "Navy",
     "Air Force",
     "Coast Guard",
     "National Oceanic and Atmospheric Administration Commissioned Corps",
     "U.S. Public Health Service Commissioned Corps",
     "I don’t know"
    ].each_with_index {|c, i| MilitaryBranch.create(:id => i+1, :name => c, :position => i+1)}
    
    ["Army and Air Force Exchange Service",
     "Navy Exchange Service Command",
     "Marine Corps Exchanges",
     "Non-Appropriated Funds Instrumentality",
     "I don’t know"
    ].each_with_index {|c, i| MilitaryEmployer.create(:id => i+1, :name => c, :position => i+1)}

    ["I earned the pension",
     "My (current, former or deceased) spouse earned the pension",
     "Other"
    ].each_with_index {|c, i| PensionEarner.create(:id => i+1, :name => c, :position => i+1)}

  end

  def self.down
    %w{
      employer_types
      federal_plans
      military_services
      military_branches
      military_employers
      pension_earners
    }.each {|tbl| drop_table tbl}
    drop_table :poverty_levels
  end
end
