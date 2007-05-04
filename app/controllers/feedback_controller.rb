class FeedbackController < ApplicationController
  
  def save_feedback
    msg = ""
    msg << "<br/>-What does your feedback concern" unless !params[:type].blank?
    msg << "<br/>-Your feedback" unless !params[:feedback].blank?
    
    if msg == ""
      Mailer.deliver_feedback(params[:type],
                              params[:feedback],
                              params[:name],
                              params[:email],
                              params[:phone],
                              params[:availability])
      flash[:success] = "Thank you. We appreciate your feedback."
      redirect_to :controller => :home
    else
      flash.now[:warning] = "Please provide us with the following information: #{msg}"
      render :action => :index
    end
  end
  
end
