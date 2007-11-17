class PlansController < ApplicationController
  before_filter :find_agency

  # GET /plans
  # GET /plans.xml
  def index
    redirect_to agencies_url
  end

  # GET /plans/1
  # GET /plans/1.xml
  def show
    redirect_to edit_agency_url(@agency) 
  end

  # GET /plans/new
  def new
    @plan = Plan.new
  end

  # GET /plans/1;edit
  def edit
    @plan = @agency.plans.find(params[:id])
    render :partial => 'plans/plan_detail', :layout => false
  end

  # POST /plans
  # POST /plans.xml
  def create
    @plan = @agency.plans.build(params[:plan])

    respond_to do |format|
      if @plan.save
        flash[:notice] = 'Plan was successfully created.'
        format.html { redirect_to edit_agency_url(@agency) }
      else
        format.html { render :action => "new" }
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
        format.html { redirect_to edit_agency_url(@agency) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /plans/1
  # DELETE /plans/1.xml
  def destroy
    @plan = @agency.plans.find(params[:id])
    @plan.destroy

    respond_to do |format|
      format.html { redirect_to edit_agency_url(@agency) }
    end
  end
  
  protected
  
  def find_agency
    @agency = Agency.find(params[:agency_id])
  end
  
end
