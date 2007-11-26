class PlansController < ApplicationController
  before_filter :find_agency, :except => [:get_counties_for_states, :get_cities_for_counties]

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
    render :partial => 'plans/plan_detail', :layout => false
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
    @plan.publication = @plan.build_publication(params[:publication])
    @plan.states = params[:plan_state_abbrevs].collect{|s| State.find(s)} unless params[:plan_state_abbrevs].nil?
    @plan.counties = params[:plan_county_ids].collect{|c| County.find(c)} unless params[:plan_county_ids].nil?
    @plan.cities = params[:plan_city_ids].collect{|c| City.find(c)} unless params[:plan_city_ids].nil?

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
    @plan = @agency.plans.find(params[:id])
    if @plan.publication
      @plan.publication.update_attributes(params[:publication])
    else
      @plan.publication = @plan.build_publication(params[:publication])
      @plan.publication.save!
    end    
    @plan.states = params[:plan_state_abbrevs].collect{|s| State.find(s)} unless params[:plan_state_abbrevs].nil?
    @plan.counties = params[:plan_county_ids].collect{|c| County.find(c)} unless params[:plan_county_ids].nil?
    @plan.cities = params[:plan_city_ids].collect{|c| City.find(c)} unless params[:plan_city_ids].nil?

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
  
end
