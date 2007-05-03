class FeedbackController < ApplicationController
  
  def save_feedback
    Mailer.deliver_feedback(params[:name],
                            params[:email],
                            params[:phone],
                            params[:availability],
                            params[:type])
    flash[:notice] = "Thank you. We appreciate your feedback."
    redirect_to :controller => :home
  end
  
end
