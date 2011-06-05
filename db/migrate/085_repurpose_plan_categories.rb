class RepurposePlanCategories < ActiveRecord::Migration
  # PlanCategories had some vestigal data that had long ago been replaced by agency.result_type_id but had never been cleaned up
  # We now have a need for plan categories, so will just re-use this table
  def self.up
    execute 'truncate table plan_categories'
    [ 'Civilian Employee (NAF and other)',
      'Farm Credit',
      'Federal Reserve',
      'Foreign Service',
      'Federal',
      'State/Local',
      'Tennessee Valley Authority',
      'Other'].each_with_index{|cat,idx| PlanCategory.create(:name => cat, :position => idx)}
    add_column :plans, :plan_category_id, :integer

    [ 'Army Non-Appropriated Fund (NAF) Employee 401(k) Savings Plan',
      'Army Non-Appropriated Fund (NAF) Employee Retirement Plan',
      'Army and Air Force Exchange Service (AAFES) Retirement Savings Plan',
      'Army and Air Force Exchange Service (AAFES) Executive Management Program Supplemental Plan',
      'Army and Air Force Exchange Service (AAFES) Retirement Annuity Plan',
      'Air Force Nonappropriated Fund (NAF) Retirement Plan for Civilian Employees',
      'Navy Installments Command (CNIC) Morale Welfare and Recreation (MWR) 401(k) Savings and Investment Plan',
      'Navy Installments Command (CNIC) Non-Appropriated Fund (NAF) Retirement Plan; Bureau of Naval Personnel (BUPERS) Retirement Plan',
      'Navy Exchange Service Command (NEXCOM) Retirement Plan for Civilian Employees',
      'Navy Exchange Service Command (NEXCOM) 401(k) Savings Plan',
      'Marine Corps Retirement Plan for Non-Appropriated Fund (NAF) Employees',
      'Marine Corps Non-Appropriated Fund (NAF) 401(k) Benefit Enhancement Program',
      'U.S. Coast Guard Non-Appropriated Funds (NAF) Retirement Plan'].each do |plan_name|
        execute  "UPDATE plans SET plan_category_id = #{PlanCategory.find_by_name('Civilian Employee (NAF and other)').id}
                  WHERE name='#{plan_name}'"
      end
  end

  def self.down
    remove_column :plans, :plan_category_id
  end
end
