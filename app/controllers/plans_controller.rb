class PlansController < ApplicationController
  before_filter :authenticate_user!, :authorized?
  before_filter :find_agency, 
                :except => [:get_counties_for_states, 
                            :get_cities_for_counties, 
                            :get_zips_for_counties,
                            :auto_complete_for_plan_catchall_employees]
  
  #auto_complete_for :plans, :catchall_employees
  
  def authorized?
    current_user.is_admin?
  end

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
    @plan.agency = @agency
    @new_restrictions = @plan.get_empty_restrictions
    #@plan.build_restriction
    @plan.is_active = true
    render :template => 'plans/edit'
  end

  # GET /plans/1;edit
  def edit
    @plan = @agency.plans.find(params[:id])
    @new_restrictions = @plan.get_empty_restrictions
    #@plan.build_restriction if !@plan.restriction
  end

  # POST /plans
  # POST /plans.xml
  def create
    if params['cancel']
      redirect_to edit_agency_url(@agency) and return
    end
    @plan = @agency.plans.build(plans_parameters)
    @plan.updated_by = current_user.login
    params[:plan][:new_locations] ||= []  # in case no checkboxes are checked
    #@plan.build_restriction if !@plan.restriction
    #update_restriction

    update_pha_contact

    is_ok = true
    @plan.transaction do
      begin
        @plan.update_restrictions(params)
        @plan.save!
      rescue
        logger.error($!)
        is_ok = false
      end
    end

    if is_ok
      flash[:notice] = 'Plan was successfully created.'
      redirect_to edit_agency_url(@agency) and return if params['update_and_return']
      redirect_to agencies_path() and return if params['update_and_list']
      redirect_to edit_agency_plan_url(:agency_id => @agency, :id => @plan)
    else
      # setting object @new_restrictions in order to correct displaying partial _new_restriction_form.rhtml
      @new_restrictions = @plan.get_empty_restrictions
      render :template => 'plans/edit' 
    end
  end

  # PUT /plans/1
  # PUT /plans/1.xml
  def update
    if params['cancel']
      redirect_to edit_agency_url(@agency) and return
    end
    @plan = @agency.plans.find(params[:id])
    @plan.updated_by = current_user.login
    params[:plan][:new_locations] ||= []  # in case no checkboxes are checked
    #@plan.build_restriction if !@plan.restriction
    #update_restriction

    update_pha_contact
    
    is_ok = true
    @plan.transaction do
      begin
        @plan.update_attributes!(plans_parameters)
        @plan.update_restrictions(params)
      rescue
        logger.error($!)
        is_ok = false
      end
    end

    if is_ok
      flash[:notice] = 'Plan was successfully updated.'
      redirect_to edit_agency_url(@agency) and return if params['update_and_return']
      redirect_to agencies_path() and return if params['update_and_list']
      redirect_to edit_agency_plan_url(:agency_id => @agency, :id => @plan)
    else
      # setting object @new_restrictions in order to correct displaying partial _new_restriction_form.rhtml
      @new_restrictions = @plan.get_empty_restrictions
      render :edit
    end
  end

  # DELETE /plans/1
  # DELETE /plans/1.xml
  def destroy
    @plan = @agency.plans.find(params[:id])
    @plan.destroy
    redirect_to edit_agency_url(@agency)
  end

  def auto_complete_for_plan_catchall_employees
    render :inline => Plan.find(params[:id]).catchall_employees.split(', ').to_s, :layout => false
  end
  
  protected
  
  def find_agency
    @agency = Agency.find(params[:agency_id])
  end
  
  def update_pha_contact
    @plan.pha_contact = PhaContact.new(params[:pha_contact][:name], params[:pha_contact][:title],
      params[:pha_contact][:phone], params[:pha_contact][:email])
  end

  private

  def plans_parameters
    params.require(:plan).permit(:is_active, :name, :name2, :plan_type1, :plan_type2, :start_date_formatted, :end_date_formatted,
                                 :govt_employee_type,:description, :comments, :covered_employees, :catchall_employees, :url_title, :url,
                                 :email, :admin_url_title, :admin_url, :spd_url_title, :spd_url, :tpa_url_title, :tpa_url,:location_hq, new_locations: [],
    restriction_attr: [:id, :minimum_age, :age_restricted_phone, :max_poverty, :age_and_income, :special_district, :other_restrictions, :delete_marker, :plan_id, :create_new])
  end

end
