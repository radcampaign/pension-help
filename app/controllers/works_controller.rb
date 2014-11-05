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
    @partner = Partner.new params[:partner]
    if @partner.save
      flash[:notice] = "Thank you for registering!"
      Mailer.deliver_npln_application(@partner) if @partner.wants_npln
      Mailer.deliver_aaa_application(@partner) if @partner.wants_pal
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
end
