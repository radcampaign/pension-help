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
    @plan = @agency.plans.build(params[:plan])
    @plan.updated_by = current_user.login
    @plan.build_restriction if !@plan.restriction
    update_restriction

    if @plan.save
      flash[:notice] = 'Plan was successfully created.'
      redirect_to edit_agency_url(@agency)
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
    @plan.build_restriction if !@plan.restriction
    update_restriction

    if @plan.update_attributes(params[:plan])
      flash[:notice] = 'Plan was successfully updated.'
      redirect_to edit_agency_url(@agency)
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
  
  def update_restriction
    @plan.restriction.update_attributes(params[:restriction])
    @plan.restriction.states=( params[:state_abbrevs].to_s.blank? ? [] : params[:state_abbrevs].collect{|s| State.find(s)} ) unless params[:state_abbrevs].nil?
    @plan.restriction.counties = ( params[:county_ids].to_s.blank? ? [] : params[:county_ids].collect{|c| County.find(c)} ) unless params[:county_ids].nil?
    @plan.restriction.counties=( params[:county_ids].to_s.blank? ? [] : params[:county_ids].collect{|c| County.find(c)} ) unless params[:county_ids].nil?
    @plan.restriction.cities=( params[:city_ids].to_s.blank? ? [] : params[:city_ids].collect{|c| City.find(c)} ) unless params[:city_ids].nil?
    @plan.restriction.zips=( params[:zip_ids].to_s.blank? ? [] : params[:zip_ids].collect{|c| Zip.find(c)} ) unless params[:zip_ids].nil?
  end
  
end
