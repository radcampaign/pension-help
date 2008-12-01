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
                          
  validates_presence_of :consultation_fee_str,
                        :message => "^Consultation fee can't be blank",
                        :if => Proc.new {|p| (p.wants_npln or p.wants_pal) and !p.new_record? and !p.basic_profile }

  validates_presence_of :hourly_rate_str,
                        :message => "^Hourly rate can't be blank",
                        :if => Proc.new {|p| (p.wants_npln or p.wants_pal) and !p.new_record? and !p.basic_profile }

  validates_format_of :consultation_fee_str,
                      :on => :update,
                      :with => /^\$?((\d+)|(\d{1,3}(,\d{3})+))(\.\d{2})?$/,
                      :message => "^Consultation fee doesn't seem to be a valid amount",
                      :if => Proc.new {|p| (p.wants_npln or p.wants_pal) and p.errors["consultation_fee_str"].nil? and !p.basic_profile }
                      
  validates_format_of :hourly_rate_str,
                      :on => :update,
                      :with => /^\$?((\d+)|(\d{1,3}(,\d{3})+))(\.\d{2})?$/,
                      :message => "^Hourly rate doesn't seem to be a valid amount",
                      :if => Proc.new {|p| (p.wants_npln or p.wants_pal) and p.errors["hourly_rate_str"].nil? and !p.basic_profile }

  attr_accessor :hourly_rate_str, :consultation_fee_str, :basic_profile                    
  
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
    self.hourly_rate = hourly_rate_str.gsub(/[$,]/,"") unless hourly_rate_str.nil?
    self.consultation_fee = consultation_fee_str.gsub(/[$,]/,"") unless consultation_fee_str.nil?
    puts (self.inspect)
  end

  #Copies errors from User to Partner(apart from Email, no need to show this error twice)
  def after_validation
    unless user.nil? or user.errors.empty?
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
