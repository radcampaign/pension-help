class WorksController < ApplicationController
  helper :partners
  
  def index
    @partner = Partner.new
    @scroll = true
#   parse_networks
  end
    
  # non-Ajax replacement for show_network_info
  def questions
    @partner = Partner.new(params[:partner])
    @partner.build_user(params[:user])
    user = params[:user]
    begin
      Partner.transaction do
        @partner.save!
        @partner.user.save!
        session[:partner] = @partner
        self.current_user = User.authenticate(user[:login], user[:password])

        Mailer.deliver_help_net_application(@partner) if @partner.wants_help
        Mailer.deliver_search_net_application(@partner) if @partner.wants_search
        Mailer.deliver_npln_application(@partner) if @partner.wants_npln
        Mailer.deliver_aaa_application(@partner) if @partner.wants_pal
        Mailer.deliver_user_application_confirmation(@partner) # sends confirmation email to user
        
        redirect_to edit_partner_path(self.current_user.partner)
      end
    rescue ActiveRecord::RecordInvalid => e
      logger.error e
      render :action => :index
    end
  end

  def thank_you

    @partner = session[:partner]
    @partner.attributes=params[:partner]
#    parse_networks
    #TODO:  clear out old values here before setting new ones
    @partner.update_multiple_answer_questions(params)
    if @partner.valid?
      if @partner.save
        # Save pensionHelp info
        if @partner.wants_help
        #  help_net = HelpNet.new(params[:help_net])
        #  help_net.partner_id = @partner.id
        #  help_net.save
          Mailer.deliver_help_net_application(@partner)
        end
        # # Save pensionSearch info
        if @partner.wants_search
        #  search_net = SearchNet.new(params[:search_net])
        #  search_net.partner_id = @partner.id
        #  search_net.save
          Mailer.deliver_search_net_application(@partner)
        end
        Mailer.deliver_npln_application(@partner) if @partner.wants_npln
        Mailer.deliver_aaa_application(@partner) if @partner.wants_pal
        Mailer.deliver_user_application_confirmation(@partner) # sends confirmation email to user
        flash[:success] = "Your application has been saved successfully."
        redirect_to '/'
      end
    else
      render :action => :questions
    end
  end

  private


end
