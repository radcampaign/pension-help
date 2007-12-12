class CreateCounselings < ActiveRecord::Migration
  def self.up
    create_table :counselings, :force => true do |t|
      t.column :zipcode, :string
      t.column :employment_start, :date
      t.column :employment_end, :date
      t.column :is_divorce_related, :boolean
      t.column :is_survivorship_related, :boolean
      t.column :work_state_abbrev, :string
      t.column :hq_state_abbrev, :string
      t.column :pension_state_abbrev, :string
      t.column :is_over_60, :boolean
      t.column :monthly_income, :integer
      t.column :number_in_household, :integer
      t.column :employer_type_id, :int
      t.column :federal_plan_id, :int
      t.column :military_service_id, :int
      t.column :military_branch_id, :int
      t.column :military_employer_id, :int
      t.column :pension_earner_id, :int
      t.column :state_abbrev, :string
      t.column :county_id, :int
      t.column :city_id, :int
    end
  end

  def self.down
    drop_table :counselings
  end
end
