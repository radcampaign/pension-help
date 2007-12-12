class WorksController < ApplicationController
  
  def index
    @scroll = true
    parse_info
    parse_networks
  end

  def show_network_info
    parse_info
    respond_to do |format|
      format.html { 
        redirect_to :action => :index, :work => @work, :msg => @msg 
      }
      format.js {
        render :update do |page| 
          page.replace_html @work, @msg 
        end
      }
    end
  end

    def show_network_form
      parse_networks
      respond_to do |format|
        format.html { 
          redirect_to :action => :index, 
                      :wants_npln => @npln,
                      :wants_pal => @aaa,
                      :wants_help => @help,
                      :wants_search => @search
        }
        format.js {
          render :update do |page| 
            page.replace_html 'networkForm', ''
            page.insert_html :bottom, 'networkForm', :partial => 'contact_info' if @npln or @aaa or @help or @search
            page.insert_html :bottom, 'networkForm', :partial => 'professions' if @help or @search
            page.insert_html :bottom, 'networkForm', :partial => 'affiliations' if @npln or @help or @search
            page.insert_html :bottom, 'networkForm', :partial => 'sponsor_types' if @npln or @help or @aaa
            page.insert_html :bottom, 'networkForm', :partial => 'plan_types' if @npln or @help or @aaa
            page.insert_html :bottom, 'networkForm', :partial => 'npln_info' if @npln
            page.insert_html :bottom, 'networkForm', :partial => 'aaa_info' if @aaa
            page.insert_html :bottom, 'networkForm', :partial => 'npln_levels' if @npln
            page.insert_html :bottom, 'networkForm', :partial => 'help_info' if @help
            page.insert_html :bottom, 'networkForm', :partial => 'search_info' if @search
            page.insert_html :bottom, 'networkForm', :partial => 'referrals' if @npln or @aaa
            page.insert_html :bottom, 'networkForm', :partial => 'additional_info' if @npln or @aaa or @help or @search
          end
        }
      end
    end
    
  # non-Ajax replacement for show_network_info
  def questions
    parse_networks
    unless @npln or @aaa or @help or @search
      flash[:warning] = "Please select at least one network"
      redirect_to :action => :index
      return
    end    
    @partner = Partner.new(params[:partner])
    if @partner.valid?
      @partner.save
      session[:partner] = @partner
    else
      render :action => :index
    end
  end
  
  def confirm
    parse_networks
    # @partner = Partner.new(params[:partner])
    # render :action => :index unless @partner.valid?
  end
  
  def thank_you
    parse_networks
    @partner = session[:partner]
    @partner.attributes=params[:partner]
    @partner.pal_additional_areas << params[:pal_additional_areas].collect{|p| PalAdditionalArea[p]} if params[:pal_additional_areas]
    @partner.pal_participation_levels << params[:pal_participation_levels].collect{|p| PalParticipationLevel[p]} if params[:pal_participation_levels]
    @partner.help_additional_areas << params[:help_additional_areas].collect{|p| HelpAdditionalArea[p]} if params[:help_additional_areas]
    @partner.professions << Profession[params[:profession]] if (params[:profession] and !params[:profession].blank?)
    @partner.search_plan_types << params[:search_plan_types].collect{|p| SearchPlanType[p]} if params[:serach_plan_types]
    @partner.npln_participation_levels << params[:npln_participation_levels].collect{|p| NplnParticipationLevel[p]} if params[:npln_participation_levels]
    @partner.referral_fees << params[:referral_fees].collect{|p| ReferralFee[p]} if params[:referral_fees]
    @partner.plan_types << params[:plan_types].collect{|p| PlanType[p]} if params[:plan_types]
    @partner.claim_types << params[:claim_types].collect{|p| ClaimType[p]} if params[:claim_types]
    @partner.sponsor_types << params[:sponsor_types].collect{|p| SponsorType[p]} if params[:sponsor_types]
    @partner.npln_additional_areas << params[:npln_additional_areas].collect{|p| NplnAdditionalArea[p]} if params[:npln_additional_areas]
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
        flash[:success] = "Your application has been saved successfully."
        redirect_to '/'
      end
    else
      render :action => :index
    end
  end
  
  private
  
  def parse_info
    @work = params[:work]
    @msg = params[:msg]
  end
  
  def parse_networks
    @npln = true if params[:wants_npln]
    @npln = true if params[:partner] and !params[:partner][:wants_npln].blank?
    @aaa = true if params[:wants_pal]
    @aaa = true if params[:partner] and !params[:partner][:wants_pal].blank?
    @help = true if params[:wants_help]
    @search = true if params[:wants_search]
  end

end
