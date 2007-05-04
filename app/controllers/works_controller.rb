class WorksController < ApplicationController

  def index
    
  end
  
  def join
    @contact = Contact.new(params[:contact])
    if @contact.save
      # Save pensionSearch info
      if !params[:wants_search].blank?
        search_net = SearchNet.new(params[:search_net])
        search_net.contact_id = @contact.id
        search_net.save
        Mailer.deliver_search_net_application(@contact,search_net)
      end
      # Save pensionHelp info
      if !params[:wants_help].blank?
        help_net = HelpNet.new(params[:help_net])
        help_net.contact_id = @contact.id
        help_net.save
        Mailer.deliver_help_net_application(@contact,help_net)
      end
      Mailer.deliver_npln_application(@contact) if @contact.wants_npln
      Mailer.deliver_aaa_application(@contact) if @contact.wants_aaa
      flash[:success] = "Your application has been saved successfully."
      redirect_to :controller => :home
    else
      render :action => :index
    end
  end

end
