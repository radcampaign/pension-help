class PartnersController < ApplicationController
  before_filter :login_required
  # layout 'admin'

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
    @partners = Partner.find(:all)

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @partners.to_xml }
    end
  end

  # GET /partners/1
  # GET /partners/1.xml
  def show
    @partner = Partner.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @partner.to_xml }
    end
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
    is_ok = true
    begin
      Partner.transaction do
        #we want to 'validate' both models
        @partner.user.attributes = params[:user]
        @partner.attributes = params[:partner]
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
      flash[:notice] = 'Information was succesfully updated.'
      redirect_to :action => :edit
    else
      render :action => 'survey'
    end
  end
  
end
