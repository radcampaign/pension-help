class CreatePartners < ActiveRecord::Migration
  def self.up
    drop_table :help_nets
    drop_table :search_nets
    drop_table :contacts    
      
    create_table :partners, :force => true do |t|
      t.column "first_name", :string, :limit => 80
      t.column "last_name", :string, :limit => 80
      t.column "middle_initial", :string, :limit => 2
      t.column "company", :string
      t.column "line_1", :string
      t.column "line_2", :string
      t.column "city", :string, :limit => 50
      t.column "state_abbrev", :string, :limit => 2
      t.column "zip_code", :string, :limit => 10
      t.column "phone", :string, :limit => 20
      t.column "fax", :string, :limit => 20
      t.column "email", :string
      t.column "url", :string
      t.column "reduced_fee_desc", :string
      t.column "contingency_fee_desc", :string
      t.column "consultation_fee", :string
      t.column "hourly_rate", :integer
      t.column "bar_admissions", :string
      t.column "aaa_member", :boolean
      t.column "willing_to_provide", :boolean
      t.column "willing_to_answer", :boolean
      t.column "wont_charge_fees", :boolean
      t.column "info_geo", :string
      t.column "info_industries", :string
      t.column "profession_other", :string
      t.column "sponsor_type_other", :string
      t.column "plan_type_other", :string
      t.column "claim_type_other", :string
      t.column "npln_additional_area_other", :string
      t.column "npln_participation_level_other", :string
      t.column "pal_additional_area_other", :string
      t.column "pal_participation_level_other", :string
      t.column "help_additional_area_other", :string
      t.column "certifications", :text
      t.column "affiliations", :text
      t.column "other_info", :text
    end
    create_table :partners_professions, :force => true, :id => false do |t|
      t.column :partner_id, :integer, :null => false
      t.column :profession_id, :integer, :null => false
    end
    execute "alter table partners_professions add primary key (partner_id, profession_id)"
    add_index :partners_professions, [:profession_id, :partner_id]
    
    create_table :partners_sponsor_types, :force => true, :id => false do |t|
      t.column :partner_id, :integer, :null => false
      t.column :sponsor_type_id, :integer, :null => false
    end
    execute "alter table partners_sponsor_types add primary key (partner_id, sponsor_type_id)"
    add_index :partners_sponsor_types, [:sponsor_type_id, :partner_id]

    create_table :partners_plan_types, :force => true, :id => false do |t|
      t.column :partner_id, :integer, :null => false
      t.column :plan_type_id, :integer, :null => false
    end
    execute "alter table partners_plan_types add primary key (partner_id, plan_type_id)"
    add_index :partners_plan_types, [:plan_type_id, :partner_id]
    
    create_table :partners_referral_fees, :force => true, :id => false do |t|
      t.column :partner_id, :integer, :null => false
      t.column :referral_fee_id, :integer, :null => false
    end
    execute "alter table partners_referral_fees add primary key (partner_id, referral_fee_id)"
    add_index :partners_referral_fees, [:referral_fee_id, :partner_id]
    
    create_table :partners_claim_types, :force => true, :id => false do |t|
      t.column :partner_id, :integer, :null => false
      t.column :claim_type_id, :integer, :null => false
    end
    execute "alter table partners_claim_types add primary key (partner_id, claim_type_id)"
    add_index :partners_claim_types, [:claim_type_id, :partner_id]
   
    create_table :partners_npln_additional_areas, :force => true, :id => false do |t|
      t.column :partner_id, :integer, :null => false
      t.column :npln_additional_area_id, :integer, :null => false
    end
    execute "alter table partners_npln_additional_areas add primary key (partner_id, npln_additional_area_id)"
    add_index :partners_npln_additional_areas, [:npln_additional_area_id, :partner_id], :name => 'partners_npln_areas'
   
    create_table :partners_npln_participation_levels, :force => true, :id => false do |t|
      t.column :partner_id, :integer, :null => false
      t.column :npln_participation_level_id, :integer, :null => false
    end
    execute "alter table partners_npln_participation_levels add primary key (partner_id, npln_participation_level_id)"
    add_index :partners_npln_participation_levels, [:npln_participation_level_id, :partner_id], :name => 'partners_npln_participations'
    
    create_table :partners_pal_additional_areas, :force => true, :id => false do |t|
      t.column :partner_id, :integer, :null => false
      t.column :pal_additional_area_id, :integer, :null => false
    end
    execute "alter table partners_pal_additional_areas add primary key (partner_id, pal_additional_area_id)"
    add_index :partners_pal_additional_areas, [:pal_additional_area_id, :partner_id], :name => 'partners_pal_areas'
   
    create_table :partners_pal_participation_levels, :force => true, :id => false do |t|
      t.column :partner_id, :integer, :null => false
      t.column :pal_participation_level_id, :integer, :null => false
    end
    execute "alter table partners_pal_participation_levels add primary key (partner_id, pal_participation_level_id)"
    add_index :partners_pal_participation_levels, [:pal_participation_level_id, :partner_id], :name => 'partners_pal_participations'
    
    create_table :partners_search_plan_types, :force => true, :id => false do |t|
      t.column :partner_id, :integer, :null => false
      t.column :search_plan_type_id, :integer, :null => false
    end
    execute "alter table partners_search_plan_types add primary key (partner_id, search_plan_type_id)"
    add_index :partners_search_plan_types, [:search_plan_type_id, :partner_id], :name => 'partners_search_plans'
    
    create_table :partners_help_additional_areas, :force => true, :id => false do |t|
      t.column :partner_id, :integer, :null => false
      t.column :help_additional_area_id, :integer, :null => false
    end
    execute "alter table partners_help_additional_areas add primary key (partner_id, help_additional_area_id)"
    add_index :partners_help_additional_areas, [:help_additional_area_id, :partner_id], :name => 'partners_help_areas'
    
  end

  def self.down
    drop_table :partners_help_additional_areas
    drop_table :partners_search_plan_types
    drop_table :partners_pal_participation_levels
    drop_table :partners_pal_additional_areas
    drop_table :partners_npln_participation_levels
    drop_table :partners_npln_additional_areas
    drop_table :partners_claim_types
    drop_table :partners_referral_fees
    drop_table :partners_plan_types
    drop_table :partners_sponsor_types
    drop_table :partners_professions    
    drop_table :partners
    create_table :help_nets do |t| t.column "name", :string end
    create_table :search_nets do |t| t.column "name", :string end
    create_table :contacts do |t| t.column "name", :string end
  end
end
