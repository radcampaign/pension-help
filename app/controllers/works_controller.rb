class WorksController < ApplicationController
  helper :partners

  # def lsp
  #   @partner = Partner.new
  #   @partner.wants_lsp = true
  # end

  def npln
    @partner = Partner.new
    @partner.wants_npln = true
  end

  def pal
    @partner = Partner.new
    @partner.wants_pal = true
  end

  def create
    @partner = Partner.new(partner_params)
    if @partner.save
      flash[:notice] = "Thank you for registering!"
      Mailer.deliver_npln_application(@partner) if @partner.wants_npln
      Mailer.aaa_application(@partner).deliver if @partner.wants_pal
      Mailer.deliver_lsp_application(@partner) if @partner.wants_lsp
      redirect_to '/works/index'
    else
      if @partner.wants_npln?
        render :action => "npln"
      elsif @partner.wants_pal?
        render :action => "pal"
      else
        # render :action => "lsp"
      end
    end
  end

  def index
    @partner = Partner.new
  end

  # non-Ajax replacement for show_network_info
  def questions
    @partner = Partner.new(params[:partner])
    # @partner.build_user(params[:user])
    # user = params[:user]
    begin
      Partner.transaction do
        @partner.save!
        # @partner.user.save!
        session[:partner] = @partner
        # self.current_user = User.authenticate(user[:login], user[:password])

        # Mailer.deliver_npln_application(@partner) if @partner.wants_npln
        # Mailer.deliver_aaa_application(@partner) if @partner.wants_pal
        # Mailer.deliver_user_application_confirmation(@partner) # sends confirmation email to user

        redirect_to edit_partner_path(self.current_user.partner)
      end
    rescue ActiveRecord::RecordInvalid => e
      logger.error e
      render :action => :index
    end
  end


  def partner_params
    params.require(:partner).permit(
        :first_name,
        :last_name,
        :company,
        :line_1,
        :line_2,
        :city,
        :state_abbrev,
        :zip_code,
        :phone,
        :fax,
        :email,
        :url,
        :other_info,
        :wants_npln,
        :wants_pal,
        :preferred_method_of_contact,
        :fee_for_initial_consultation,
        :hourly_continuous_fee,
        :professional_certifications_and_affiliations,
        :has_other_areas_of_expertise,
        :other_areas_of_expertise,
        :dr_lawyer,
        :has_other_level_of_participation,
        :other_level_of_participation,
        :law_practice_states,
        :law_practice_circuits,
        :us_supreme_court,
        :malpractice_insurance,
        :tollfree_number,
        :local_number,
        :office_location,
        :wants_lsp,
        :expertise_ids => [],
        :assistance_ids => []
    )
  end


end
