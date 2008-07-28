class PlansController < ApplicationController
  before_filter :login_required
  before_filter :find_agency, :except => [:get_counties_for_states, :get_cities_for_counties, :get_zips_for_counties]
  layout 'admin'

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
    @plan.build_restriction
    @plan.is_active = true
    render :template => 'plans/edit'
#    render :partial => 'plans/plan_detail', :layout => false
  end

  # GET /plans/1;edit
  def edit
    @plan = @agency.plans.find(params[:id])
    @plan.build_restriction if !@plan.restriction
#    render :partial => 'plans/plan_detail', :layout => false
  end

  # POST /plans
  # POST /plans.xml
  def create
    if @params['cancel']
      redirect_to edit_agency_url(@agency) and return
    end
    @plan = @agency.plans.build(params[:plan])
    @plan.updated_by = current_user.login
    @plan.restriction = Restriction.create_restriction params

    update_pha_contact
    if @plan.save
      flash[:notice] = 'Plan was successfully created.'
      redirect_to edit_agency_url(@agency) and return if @params['update_and_return']
      redirect_to agencies_path() and return if params['update_and_list']
      redirect_to edit_plan_url(:agency_id => @agency, :id => @plan)
    else
      render :action => "new"
    end
  end

  # PUT /plans/1
  # PUT /plans/1.xml
  def update
    if @params['cancel']
      redirect_to edit_agency_url(@agency) and return
    end
    @plan = @agency.plans.find(params[:id])
    @plan.updated_by = current_user.login
    if @plan.restriction
      @plan.restriction.update_restriction params
    else
      @plan.restriction = Restriction.create_restriction params
    end

    update_pha_contact
    if @plan.update_attributes(params[:plan])
      @plan.restriction.save if @plan.restriction
      flash[:notice] = 'Plan was successfully updated.'
      redirect_to edit_agency_url(@agency) and return if @params['update_and_return']
      redirect_to agencies_path() and return if params['update_and_list']
      redirect_to edit_plan_url(:agency_id => @agency, :id => @plan)
    else
      render :action => "edit"
    end
  end

  # DELETE /plans/1
  # DELETE /plans/1.xml
  def destroy
    @plan = @agency.plans.find(params[:id])
    @plan.destroy
    redirect_to edit_agency_url(@agency)
  end
  
  protected
  
  def find_agency
    @agency = Agency.find(params[:agency_id])
  end
  
  def update_pha_contact
    @plan.pha_contact = PhaContact.new(params[:pha_contact][:name], params[:pha_contact][:title],
      params[:pha_contact][:phone], params[:pha_contact][:email])
  end
end
