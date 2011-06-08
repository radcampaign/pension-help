class AddFederalPlans < ActiveRecord::Migration
  def self.up
    FederalPlan.enumeration_model_updates_permitted = true
    Agency.find_by_name("Farm Credit Administration").update_attributes(:result_type_id => ResultType.find_by_name("FCD").id, :agency_category_id => AgencyCategory.find_by_name("Farm Credit Plan").id)
    Agency.find(:all, :conditions => ["name in (?)", ["Farm Credit Foundations", "CoBank", "AgFirst Bank Farm Credit Bank", "Farm Credit Bank of Texas"]]).each{|a| a.update_attributes(:agency_category_id => AgencyCategory.find_by_name("Farm Credit Plan").id)}
    other_plan = FederalPlan.find_by_name('other')
    other_plan.update_attribute("name", "Other federal employee retirement plans")
    if Plan.find_by_name("Thrift Savings Plan").nil?
      Plan.create(:name => "Thrift Savings Plan", :agency_id => Agency.find_by_name('Federal Retirement Thrift Investment Board'))
    else
      FederalPlan.find_by_name("Thrift Savings Plan (TSP)").update_attribute(:associated_plan_id, Plan.find_by_name("Thrift Savings Plan").id)
    end
puts "Adding other Federal Plans"
    FederalPlan.create(:name => "Central Intelligence Agency Voluntary Investment Plan",
                       :parent_id => other_plan.id,
                       :position => 1,
                       :associated_plan_id => Plan.find_by_name("Central Intelligence Agency Voluntary Investment Plan").id)
    FederalPlan.create(:name => "Comptroller General Retirement Plan",
                       :parent_id => other_plan.id,
                       :position => 2,
                       :associated_plan_id => Plan.find_by_name("Comptroller General Retirement Plan").id)
    fed_judiciary_plan = FederalPlan.create(:name => "Federal Judiciary Plans",
                       :parent_id => other_plan.id,
                       :position => 3)
    FederalPlan.create(:name => "Federal Park Police Retirement Plan",
                       :parent_id => other_plan.id,
                       :position => 4,
                       :associated_plan_id => Plan.find_by_name("The District of Columbia Police Officers' and Firefighters' Retirement Plan (DCPOFP)").id)
    fed_reserve_plan = FederalPlan.create( :name => "Federal Reserve Bank or Board Plans",
                        :parent_id => other_plan.id,
                        :position => 5 )
    foreign_service_plan = FederalPlan.create( :name => "Foreign Service Plans",
                        :parent_id => other_plan.id,
                        :position => 6 )
    tva_plan = FederalPlan.create( :name => "Tennessee Valley Authority Plans",
                        :parent_id => other_plan.id,
                        :position => 7 )
    FederalPlan.create(:name => "U.S. Secret Service Plan",
                       :parent_id => other_plan.id,
                       :position => 8,
                       :associated_plan_id => Plan.find_by_name("The District of Columbia Police Officers' and Firefighters' Retirement Plan (DCPOFP)").id)
puts "Adding Judiciary plans"
    FederalPlan.create(:name => "Federal Judicial Retirement System",
                       :parent_id => fed_judiciary_plan.id,
                       :position => 1,
                       :associated_plan_id => Plan.find_by_name("The Federal Judicial Retirement System").id)
    FederalPlan.create(:name => "Judicial Officers' Retirement Fund",
                       :parent_id => fed_judiciary_plan.id,
                       :position => 2,
                       :associated_plan_id => Plan.find_by_name("Judicial Officers' Retirement Fund").id)
    FederalPlan.create(:name => "Judicial Survivors' Annuity System (JSAS)",
                       :parent_id => fed_judiciary_plan.id,
                       :position => 3,
                       :associated_plan_id => Plan.find_by_name("Judicial Survivors' Annuity System (JSAS)").id)
    FederalPlan.create(:name => "Judiciary of the Territories Retirement System",
                       :parent_id => fed_judiciary_plan.id,
                       :position => 4,
                       :associated_plan_id => Plan.find_by_name("Judiciary of the Territories Retirement System").id)
    FederalPlan.create(:name => "United States Court of Federal Claims Judges' Retirement System ",
                       :parent_id => fed_judiciary_plan.id,
                       :position => 5,
                       :associated_plan_id => Plan.find_by_name("United States Court of Federal Claims Judges' Retirement System ").id)
puts "Adding Federal Reserve plans"
    FederalPlan.create(:name => "Federal Reserve Banks Retirement Plan",
                       :parent_id => fed_reserve_plan.id,
                       :position => 1,
                       :associated_plan_id => Plan.find_by_name("The Federal Reserve Banks Retirement Plan").id)
    FederalPlan.create(:name => "Federal Reserve Banks Thrift Plan",
                       :parent_id => fed_reserve_plan.id,
                       :position => 2,
                       :associated_plan_id => Plan.find_by_name("The Federal Reserve Banks Thrift Plan").id)
    FederalPlan.create(:name => "Federal Reserve Banks Board Retirement Plan",
                       :parent_id => fed_reserve_plan.id,
                       :position => 3,
                       :associated_plan_id => Plan.find_by_name("The Federal Reserve Banks Board Retirement Plan").id)
    FederalPlan.create( :name => "Financial Institutions Retirement Fund (FIRF) Defined Benefit Plan",
                        :parent_id => fed_reserve_plan.id,
                        :position => 4,
                        :associated_plan_id => Plan.find_by_name("Financial Institutions Retirement Fund (FIRF) Defined Benefit Plan").id)

    FederalPlan.create( :name => "Financial Institutions Thrift Plan (FITP)",
                        :parent_id => fed_reserve_plan.id,
                        :position => 5,
                        :associated_plan_id => Plan.find_by_name("Financial Institutions Thrift Plan (FITP)").id)
puts "Adding foreign service plans"
    FederalPlan.create( :name => "Foreign Service Pension System (FSPS)",
                        :parent_id => foreign_service_plan.id,
                        :position => 1,
                        :associated_plan_id => Plan.find_by_name("Foreign Service Pension System (FSPS)").id)
    FederalPlan.create( :name => "Foreign Service Retirement and Disability System (FSRDS)",
                        :parent_id => foreign_service_plan.id,
                        :position => 2,
                        :associated_plan_id => Plan.find_by_name("Foreign Service Retirement and Disability System (FSRDS)").id)
    FederalPlan.create( :name => "Foreign Service Retirement and Disability System-Offset Plan (FSRDS Offset)",
                        :parent_id => foreign_service_plan.id,
                        :position => 3,
                        :associated_plan_id => Plan.find_by_name("The Foreign Service Retirement and Disability System-Offset Plan (FSRDS Offset)").id)
puts "Adding TVA plans"
    FederalPlan.create( :name => "Tennessee Valley Authority 401(k)",
                        :parent_id => tva_plan.id,
                        :position => 1,
                        :associated_plan_id => Plan.find_by_name("Tennessee Valley Authority 401(k)").id)
    FederalPlan.create( :name => "Tennessee Valley Authority Retirement System",
                        :parent_id => tva_plan.id,
                        :position => 2,
                        :associated_plan_id => Plan.find_by_name("Tennessee Valley Authority Retirement System").id)

  end

  def self.down
    first_plan_added = FederalPlan.find_by_name("Central Intelligence Agency Voluntary Investment Plan")
    execute "DELETE from federal_plans where id >= #{first_plan_added.id}"
    execute "UPDATE federal_plans SET name='Other' WHERE name = 'Other federal employee retirement plan'"
  end
end
