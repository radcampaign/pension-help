# == Schema Information
#
# Table name: partners
#
#  id                                           :integer          not null, primary key
#  first_name                                   :string(80)
#  last_name                                    :string(80)
#  company                                      :string(255)
#  line_1                                       :string(255)
#  line_2                                       :string(255)
#  city                                         :string(50)
#  state_abbrev                                 :string(2)
#  zip_code                                     :string(10)
#  phone                                        :string(20)
#  fax                                          :string(20)
#  email                                        :string(255)
#  url                                          :string(255)
#  other_info                                   :text
#  wants_npln                                   :boolean          default(FALSE)
#  wants_pal                                    :boolean          default(FALSE)
#  preferred_method_of_contact                  :integer
#  fee_for_initial_consultation                 :string(255)
#  hourly_continuous_fee                        :string(255)
#  professional_certifications_and_affiliations :string(255)
#  has_other_areas_of_expertise                 :boolean          default(FALSE)
#  other_areas_of_expertise                     :string(255)
#  dr_lawyer                                    :boolean          default(FALSE)
#  has_other_level_of_participation             :boolean          default(FALSE)
#  other_level_of_participation                 :string(255)
#  law_practice_states                          :string(255)
#  law_practice_circuits                        :string(255)
#  us_supreme_court                             :boolean          default(FALSE)
#  malpractice_insurance                        :boolean          default(FALSE)
#  tollfree_number                              :string(255)
#  local_number                                 :string(255)
#  office_location                              :text
#  wants_lsp                                    :boolean          default(FALSE)
#

class Partner < ActiveRecord::Base
  has_and_belongs_to_many :professions
  has_and_belongs_to_many :sponsor_types
  has_and_belongs_to_many :plan_types
  has_and_belongs_to_many :referral_fees
  has_and_belongs_to_many :claim_types, :join_table => "partners_claim_types"
  has_and_belongs_to_many :npln_additional_areas,
                          :join_table => "partners_npln_additional_areas"
  has_and_belongs_to_many :npln_participation_levels,
                          :join_table => "partners_npln_participation_levels"
  has_and_belongs_to_many :pal_additional_areas,
                          :join_table => "partners_pal_additional_areas"
  has_and_belongs_to_many :pal_participation_levels,
                          :join_table => "partners_pal_participation_levels"
  has_and_belongs_to_many :search_plan_types
  has_and_belongs_to_many :help_additional_areas,
                          :join_table => "partners_help_additional_areas"
  has_and_belongs_to_many :jurisdictions,
                          :join_table => "partners_jurisdictions"
  has_and_belongs_to_many :geo_areas,
                          :join_table => "partners_geo_areas"

  has_and_belongs_to_many :expertises
  has_and_belongs_to_many :assistances
  has_and_belongs_to_many :practices
  has_and_belongs_to_many :participations
  has_and_belongs_to_many :fee_arrangements

  validates_presence_of   :first_name, :last_name, :line_1, :city,
                          :state_abbrev, :zip_code, :phone, :email

  validate :validate_wants

  attr_accessor :basic_profile

  #Updates questions answers from request params.
  def update_multiple_answer_questions params
    #clear questions first
    self.pal_additional_areas.clear
    self.pal_participation_levels.clear
    self.help_additional_areas.clear
    self.professions.clear
    self.search_plan_types.clear
    self.npln_participation_levels.clear
    self.referral_fees.clear
    self.plan_types.clear
    self.claim_types.clear
    self.sponsor_types.clear
    self.npln_additional_areas.clear
    self.jurisdictions.clear
    self.geo_areas.clear

    self.pal_additional_areas << params[:pal_additional_areas].collect{|p| PalAdditionalArea[p]} if params[:pal_additional_areas]
    self.pal_participation_levels << params[:pal_participation_levels].collect{|p| PalParticipationLevel[p]} if params[:pal_participation_levels]
    self.help_additional_areas << params[:help_additional_areas].collect{|p| HelpAdditionalArea[p]} if params[:help_additional_areas]
    self.professions << Profession[params[:profession]] if (params[:profession] and !params[:profession].blank?)
    self.search_plan_types << params[:search_plan_types].collect{|p| SearchPlanType[p]} if params[:serach_plan_types]
    self.npln_participation_levels << params[:npln_participation_levels].collect{|p| NplnParticipationLevel[p]} if params[:npln_participation_levels]
    self.referral_fees << params[:referral_fees].collect{|p| ReferralFee[p]} if params[:referral_fees]
    self.plan_types << params[:plan_types].collect{|p| PlanType[p]} if params[:plan_types]
    self.claim_types << params[:claim_types].collect{|p| ClaimType[p]} if params[:claim_types]
    self.sponsor_types << params[:sponsor_types].collect{|p| SponsorType[p]} if params[:sponsor_types]
    self.npln_additional_areas << params[:npln_additional_areas].collect{|p| NplnAdditionalArea[p]} if params[:npln_additional_areas]
    self.jurisdictions << params[:jurisdictions].collect{|p| Jurisdiction[p]} if params[:jurisdictions]
    self.geo_areas << params[:geo_areas].collect{|p| GeoArea[p]} if params[:geo_areas]
  end


  protected


  def validate_wants
    if self.wants_pal
      if self.assistances.size == 0
        self.errors.add(:assistances, "is required")
      end
    elsif self.wants_lsp
      if self.company.blank?
        self.errors.add(:company, "can't be blank")
      end
    end
  end
end
