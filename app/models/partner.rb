# == Schema Information
# Schema version: 41
#
# Table name: partners
#
#  id                             :integer(11)   not null, primary key
#  first_name                     :string(80)    
#  last_name                      :string(80)    
#  middle_initial                 :string(2)     
#  company                        :string(255)   
#  line_1                         :string(255)   
#  line_2                         :string(255)   
#  city                           :string(50)    
#  state_abbrev                   :string(2)     
#  zip_code                       :string(10)    
#  phone                          :string(20)    
#  fax                            :string(20)    
#  email                          :string(255)   
#  url                            :string(255)   
#  reduced_fee_desc               :string(255)   
#  contingency_fee_desc           :string(255)   
#  consultation_fee               :string(255)   
#  hourly_rate                    :integer(11)   
#  bar_admissions                 :string(255)   
#  aaa_member                     :boolean(1)    
#  willing_to_provide             :boolean(1)    
#  willing_to_answer              :boolean(1)    
#  wont_charge_fees               :boolean(1)    
#  info_geo                       :string(255)   
#  info_industries                :string(255)   
#  profession_other               :string(255)   
#  sponsor_type_other             :string(255)   
#  plan_type_other                :string(255)   
#  claim_type_other               :string(255)   
#  npln_additional_area_other     :string(255)   
#  npln_participation_level_other :string(255)   
#  pal_additional_area_other      :string(255)   
#  pal_participation_level_other  :string(255)   
#  help_additional_area_other     :string(255)   
#  certifications                 :text          
#  affiliations                   :text          
#  other_info                     :text          
#  wants_npln                     :boolean(1)    
#  wants_pal                      :boolean(1)    
#  wants_help                     :boolean(1)    
#  wants_search                   :boolean(1)    
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

  belongs_to :user

  validates_presence_of   :first_name, 
                          :last_name, 
                          :line_1, 
                          :city, 
                          :state_abbrev, 
                          :zip_code, 
                          :phone, 
                          :email
                          
  validates_numericality_of :hourly_rate,
                            :if => Proc.new {|p| !p.new_record? and (p.wants_npln or p.wants_pal) }
  validates_numericality_of :consultation_fee,
                            :if => Proc.new {|p| !p.new_record? and (p.wants_npln or p.wants_pal) }

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
  end

  protected
  #Adds to a new User default role - NETWORK_USER_ROLE, only when creating a new partner
  def before_validation_on_create
    #copy email from partner to user, add role
    if !user.nil?
      user.roles << Role.find_by_role_name(NETWORK_USER_ROLE)
    end
  end

  #Copies email from Partner to User
  def before_validation
    if !user.nil? 
      user.email = self.email
    end
  end

  #Copies errors from User to Partner(apart from Email, no need to show this error twice)
  def after_validation
    unless user.errors.empty?
      user.errors.each do |attr, mesg|
        self.errors.add attr, mesg unless (attr == 'email' && mesg != 'has already been taken')
      end
    end
  end

  def validate
    result = true
    #Validates network selection
    if (wants_npln.blank? or !wants_npln) &&
        (wants_pal.blank? or !wants_pal) && 
        (wants_help.blank? or !wants_help) && 
        (wants_search.blank? or !wants_search)
      self.errors.add_to_base('Please select at least one network')
      result = false;
    end
    #Validates user
    if user.nil? || !user.valid?
      result = false
    end
    return result
  end
end
