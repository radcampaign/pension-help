class EmailThisPageController < ApplicationController

  def new
    @email = PageEmail.new
    @email.page_title = PageEmail.get_page_title(params[:link])
    @email.link = params[:link]
    puts ''
  end

  def create
    @email = PageEmail.new(params[:email])

    if @email.save
      Mailer.deliver_page_email(@email, 'www.pensionhelp.org')
      flash[:notice] = "Email was sent."
    else
      render :action => 'new'
    end
  end
end