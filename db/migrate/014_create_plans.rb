class CreatePlans < ActiveRecord::Migration
  def self.up
    create_table :plans do |t|
      t.column :name, :string
      t.column :name2, :string
      t.column :agency_id, :integer
      t.column :start_date, :date
      t.column :end_date, :date
      t.column :covered_employees, :text
      t.column :catchall_employees, :text
      t.column :description, :text
      t.column :service_description, :text
      t.column :comments, :text
      t.column :status, :string
      t.column :govt_employee_type, :string
      t.column :special_district, :string
      t.column :plan_type1, :string
      t.column :plan_type2, :string
      t.column :plan_type3, :string
      t.column :url, :string
      t.column :url_title, :string
      t.column :admin_url, :string
      t.column :admin_url_title, :string
      t.column :tpa_url, :string
      t.column :tpa_url_title, :string
      t.column :spd_url, :string
      t.column :spd_url_title, :string
      t.column :plan_category_id, :integer
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
      t.column :updated_by, :string
    end
  end

  def self.down
    drop_table :plans
  end
end
