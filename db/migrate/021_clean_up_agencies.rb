class CleanUpAgencies < ActiveRecord::Migration
  def self.up
    begin
      drop_table :addresses
      drop_table :locations_counties
      drop_table :locations_states
      drop_table :locations
      drop_table :plan_categories
      drop_table :plans_states
      drop_table :plans_cities
      drop_table :plans_counties
      drop_table :plans_zips
      drop_table :plans
      drop_table :publications
      drop_table :agencies
      drop_table :agency_types
    rescue
    end
    
    create_table :result_types, :force => true do |t|
      t.column :name, :string
      t.column :position, :integer
    end

    create_table :agency_categories, :force => true do |t|
      t.column :name, :string
      t.column :position, :integer
    end
    
    create_table :agencies, :force => true do |t|
      t.column :agency_category_id, :integer
      t.column :result_type_id, :integer
      t.column :name, :string
      t.column :name2, :string
      t.column :description, :text
      t.column :data_source, :string
      t.column :is_active, :boolean
      t.column :url, :string
      t.column :url_title, :string
      t.column :url2, :string
      t.column :url2_title, :string
      t.column :comments, :text
      t.column :services_provided, :text
      t.column :use_for_counseling, :boolean
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
      t.column :updated_by, :string
      t.column :legacy_code, :string, :limit => 10
      t.column :legacy_status, :string
      t.column :legacy_category1, :string
      t.column :legacy_category2, :string
      t.column :fmp2_code, :string, :limit => 10
    end
    
    create_table :locations, :force => true do |t|
      t.column :agency_id, :integer
      t.column :name, :string
      t.column :name2, :string
      t.column :is_hq, :boolean
      t.column :is_provider, :boolean
      t.column :tollfree, :string, :limit => 20
      t.column :tollfree_ext, :string, :limit => 10
      t.column :phone, :string, :limit => 20
      t.column :phone_ext, :string, :limit => 10
      t.column :tty, :string, :limit => 20
      t.column :tty_ext, :string, :limit => 10
      t.column :fax, :string, :limit => 20
      t.column :email, :string
      t.column :hours_of_operation, :string
      t.column :logistics, :string
      t.column :updated_at, :datetime
      t.column :legacy_code, :string, :limit => 10
      t.column :legacy_subcode, :string, :limit => 10
      t.column :fmp2_code, :string, :limit => 10
    end
    
    create_table :addresses, :force => true do |t|
      t.column :location_id, :integer
      t.column :line1, :string
      t.column :line2, :string
      t.column :city, :string, :limit => 64
      t.column :state_abbrev, :string
      t.column :zip, :string
      t.column :address_type, :string
      t.column :legacy_code, :string, :limit => 10
      t.column :legacy_subcode, :string, :limit => 10
      t.column :fmp2_code, :string, :limit => 10
    end
    
    create_table :publications, :force => true do |t|
      t.column :agency_id, :integer
      t.column :tollfree, :string, :limit => 20
      t.column :tollfree_ext, :string, :limit => 10
      t.column :phone, :string, :limit => 20
      t.column :phone_ext, :string, :limit => 10
      t.column :tty, :string, :limit => 20
      t.column :tty_ext, :string, :limit => 10
      t.column :fax, :string, :limit => 20
      t.column :email, :string
      t.column :url, :string
      t.column :url_title, :string
      t.column :legacy_code, :string, :limit => 10
      t.column :fmp2_code, :string, :limit => 10
    end
    
    create_table :plans, :force => true do |t|
      t.column :agency_id, :integer
      t.column :name, :string
      t.column :name2, :string
      t.column :description, :text
      t.column :comments, :text
      t.column :start_date, :date
      t.column :end_date, :date
      t.column :covered_employees, :text
      t.column :catchall_employees, :text
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
      t.column :govt_employee_type, :string
      t.column :special_district, :string
      t.column :fmp2_code, :string
      t.column :legacy_category, :string
      t.column :legacy_status, :string
      t.column :legacy_geo_type, :string
      t.column :legacy_geo_info, :text
      t.column :legacy_counties, :string
      t.column :legacy_states, :string
    end
  end

  def self.down
    
  end
end
