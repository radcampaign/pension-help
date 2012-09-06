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


  def validate
    if self.assistances.count == 0 and !self.wants_npln
      self.errors.add(:assistances, "is required")
    end
  end
end