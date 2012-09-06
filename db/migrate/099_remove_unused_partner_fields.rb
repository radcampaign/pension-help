class RemoveUnusedPartnerFields < ActiveRecord::Migration
  def self.up
    remove_column :partners, :middle_initial
    remove_column :partners, :reduced_fee_desc
    remove_column :partners, :contingency_fee_desc
    remove_column :partners, :consultation_fee
    remove_column :partners, :hourly_rate
    remove_column :partners, :bar_admissions
    remove_column :partners, :aaa_member
    remove_column :partners, :willing_to_provide
    remove_column :partners, :willing_to_answer
    remove_column :partners, :wont_charge_fees
    remove_column :partners, :info_geo
    remove_column :partners, :info_industries
    remove_column :partners, :profession_other
    remove_column :partners, :sponsor_type_other
    remove_column :partners, :plan_type_other
    remove_column :partners, :claim_type_other
    remove_column :partners, :npln_additional_area_other
    remove_column :partners, :npln_participation_level_other
    remove_column :partners, :pal_additional_area_other
    remove_column :partners, :pal_participation_level_other
    remove_column :partners, :help_additional_area_other
    remove_column :partners, :certifications
    remove_column :partners, :affiliations
    remove_column :partners, :wants_help
    remove_column :partners, :wants_search
    remove_column :partners, :user_id
    remove_column :partners, :consultation_fee_desc
    remove_column :partners, :hourly_rate_desc
    remove_column :partners, :fee_shifting_desc
    remove_column :partners, :willing_to_provide_plan_info
  end

  def self.down
    # One-way migration.
  end
end
