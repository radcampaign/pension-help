class FeedbackController < ApplicationController

  before_filter :authenticate_user!, :authorized?, :only => [:index, :show, :edit, :update]

  require 'will_paginate/array'

  def authorized?
    current_user.is_admin?
  end

  def show_form
    @feedback = Feedback.new
    render :template => 'feedback/save_feedback', :layout => 'application'
  end

  def save_feedback
    @feedback = Feedback.new(feedback_params)
    if @feedback.save
      Mailer.feedback(@feedback).deliver
      flash[:success] = "Thank you. We appreciate your feedback."
      redirect_to '/'
    else
      render :template => 'feedback/save_feedback', :layout => 'application'
    end
  end

  def index
    #show unresolved as default
    params[:resolved] = '0' if params[:resolved].blank?
    p = Feedback.get_parameters_for_pagination(params)
    @feedbacks = Feedback.where(p[:conditions]).order(p[:order]).paginate(:page => params[:page]).per_page(20)
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
      if @feedback.update_attributes(feedback_params)
        @feedback.add_comment(params[:comment], current_user)
        flash[:notice] = 'Feedback was successfully updated.'
        format.html { redirect_to feedback_url(@feedback) }
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml { render :xml => @feedback.errors.to_xml }
      end
    end
  end

  private


  def feedback_params
    params.require(:feedback).permit(:title, :name, :email, :phone, :availability, :state_abbrev, :category, :resolved, :feedback, :is_resolved)
  end

end
