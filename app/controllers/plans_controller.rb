class PlansController < ApplicationController
  before_filter :find_agency

  # GET /plans
  # GET /plans.xml
  def index
    @plans = @agency.plans.find(:all)

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @plans.to_xml }
    end
  end

  # GET /plans/1
  # GET /plans/1.xml
  def show
    @plan = @agency.plans.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @plan.to_xml }
    end
  end

  # GET /plans/new
  def new
    @plan = Plan.new
  end

  # GET /plans/1;edit
  def edit
    @plan = @agency.plans.find(params[:id])
  end

  # POST /plans
  # POST /plans.xml
  def create
    @plan = @agency.plans.build(params[:plan])

    respond_to do |format|
      if @plan.save
        flash[:notice] = 'Plan was successfully created.'
        format.html { redirect_to plan_url(@agency, @plan) }
        format.xml  { head :created, :location => plan_url(@agency, @plan) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @plan.errors.to_xml }
      end
    end
  end

  # PUT /plans/1
  # PUT /plans/1.xml
  def update
    @plan = @agency.plans.find(params[:id])

    respond_to do |format|
      if @plan.update_attributes(params[:plan])
        flash[:notice] = 'Plan was successfully updated.'
        format.html { redirect_to plan_url(@agency, @plan) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @plan.errors.to_xml }
      end
    end
  end

  # DELETE /plans/1
  # DELETE /plans/1.xml
  def destroy
    @plan = @agency.plans.find(params[:id])
    @plan.destroy

    respond_to do |format|
      format.html { redirect_to plans_url }
      format.xml  { head :ok }
    end
  end
  
  protected
  
  def find_agency
    @agency = Agency.find(params[:agency_id])
  end
  
end
