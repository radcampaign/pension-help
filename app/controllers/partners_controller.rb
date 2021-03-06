class PartnersController < ApplicationController
  before_filter :authenticate_user!, :authorized?

  def authorized?
    if current_user.is_admin?
      true
    else
      #actions allowed for NETWORK USER + do not let them to access other partners data
      %w[show edit update survey update_survey].include?(@action_name) and current_user.partner.id.to_s == params[:id]
    end
  end

  # GET /partners
  # GET /partners.xml
  def index
    @partners = Partner.all

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @partners.to_xml }
    end
  end

  # GET /partners/1
  # GET /partners/1.xml
  def show
    redirect_to edit_partner_url()
  end

  # GET /partners/new
  def new
    @partner = Partner.new
  end

  # GET /partners/1;edit
  def edit
    @partner = Partner.find(params[:id])
  end

  # POST /partners
  # POST /partners.xml
  def create
    @partner = Partner.new(params[:partner])
    @partner.build_user(params[:user])

    is_ok = true
    begin
      Partner.transaction do
        @partner.save!
        @partner.user.save!
      end
    rescue ActiveRecord::RecordInvalid => e
      logger.error e
      is_ok = false
    end

    if is_ok
      flash[:notice] = 'Partner was successfully created.'
      redirect_to partner_url(@partner) 
    else
      render :action => "new" 
    end
  end

  # PUT /partners/1
  # PUT /partners/1.xml
  def update
    @partner = Partner.find(params[:id])
    @partner.basic_profile = false    # we're only editing basic info here, not extended partner info (see update_survey)
    is_ok = true
    begin
      Partner.transaction do
        #we want to 'validate' both models
        @partner.user.attributes = params[:user]
        @partner.attributes = params[:partner]
        @partner.update_multiple_answer_questions(params)
        @partner.update_attributes!(params[:partner])    
        @partner.save!
        @partner.user.save!
      end
    rescue ActiveRecord::RecordInvalid => e
      logger.error e
      is_ok = false
    end

    if is_ok
      flash[:notice] = 'Partner profile was successfully updated.'
      redirect_to :action => :edit
    else
      render :action => "edit"
    end
  end

  # DELETE /partners/1
  # DELETE /partners/1.xml
  def destroy
    @partner = Partner.find(params[:id])
    @partner.destroy

    respond_to do |format|
      format.html { redirect_to partners_url }
      format.xml  { head :ok }
    end
  end
  
  def survey
    @partner = Partner.find(params[:id])
  end

  def update_survey
    @partner = Partner.find(params[:id])
    @partner.basic_profile = false    # we're editing extended partner info here, not just basic profile (see update)
    is_ok = true
    begin
      Partner.transaction do
        @partner.update_multiple_answer_questions(params)
        @partner.update_attributes!(params[:partner])
      end
    rescue ActiveRecord::RecordInvalid => e
      logger.error e
      is_ok = false
    end

    if is_ok
      flash[:notice] = 'Thank you. Your profile was succesfully updated.'
      redirect_to edit_partner_path(@partner)
      # redirect_to :action => :survey, :id => @partner.id
    else
      render :action => 'survey'
    end
  end

  private
    def partner_layout
      current_user and current_user.is_admin? ? 'admin' : 'default'
    end
  
end
