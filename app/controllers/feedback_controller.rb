class FeedbackController < ApplicationController
  layout 'admin', :except => [:show_form, :save_feedback]
  before_filter :login_required, :only => [:index,:show,:edit,:update]

  def authorized?
    current_user.is_admin?
  end

  def show_form
    render :template => 'feedback/save_feedback', :layout => 'default'
  end
  
  def save_feedback
    @feedback = Feedback.new(params[:feedback])

    if @feedback.save
      Mailer.deliver_feedback(@feedback)
      flash[:success] = "Thank you. We appreciate your feedback."
      redirect_to '/'
    else
      render :template => 'feedback/save_feedback', :layout => 'default'
    end
  end
  
  def index
    #show unresolved as default
    params[:resolved] = '0' if params[:resolved].blank?
    p = Feedback.get_parameters_for_pagination(params)
    
    @paginator,@feedbacks = paginate :feedback, :per_page => 20, :select => p[:select],
        :conditions => p[:conditions], :order => p[:order]
  end
  
  def show
    @feedback = Feedback.find(params[:id])
    @comments = Comment.find_comments_for_commentable('Feedback', @feedback.id)
  end
  
  def edit
    @feedback = Feedback.find(params[:id])
    @comments = Comment.find_comments_for_commentable('Feedback', @feedback.id)
  end
  
  def update
    @feedback = Feedback.find(params[:id])
    @comments = Comment.find_comments_for_commentable('Feedback', @feedback.id)

    respond_to do |format|
      if @feedback.update_attributes(params[:feedback])
        @feedback.add_comment(params[:comment], current_user)
        flash[:notice] = 'Feedback was successfully updated.'
        format.html { redirect_to feedback_url(@feedback) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @feedback.errors.to_xml }
      end
    end
  end
  
end
