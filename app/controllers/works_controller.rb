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
                    :wants_aaa => @aaa,
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
  
  def confirm
    parse_networks
    unless @npln or @aaa or @help or @search
      flash[:warning] = "Please select at least one network"
      redirect_to :action => :index
      return
    end    
    @contact = Contact.new(params[:contact])
    render :action => :index unless @contact.valid?
  end
  
  def thank_you
    parse_networks
    @contact = Contact.new(params[:contact])
    if @contact.valid?
    # For Demo:
    #if @contact.save
      # Save pensionHelp info
      #if @help
      #  help_net = HelpNet.new(params[:help_net])
      #  help_net.contact_id = @contact.id
      #  help_net.save
      #  Mailer.deliver_help_net_application(@contact,help_net)
      #end
      # Save pensionSearch info
      #if @search
      #  search_net = SearchNet.new(params[:search_net])
      #  search_net.contact_id = @contact.id
      #  search_net.save
      #  Mailer.deliver_search_net_application(@contact,search_net)
      #end
      #Mailer.deliver_npln_application(@contact) if @contact.wants_npln
      #Mailer.deliver_aaa_application(@contact) if @contact.wants_aaa
      #flash[:success] = "Your application has been saved successfully."
      #redirect_to '/'
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
    @npln = true if params[:contact] and !params[:contact][:wants_npln].blank?
    @aaa = true if params[:wants_aaa]
    @aaa = true if params[:contact] and !params[:contact][:wants_aaa].blank?
    @help = true if params[:wants_help]
    @search = true if params[:wants_search]
  end

end
