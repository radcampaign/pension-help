class LocationsController < ApplicationController
  before_filter :authenticate_user!, :authorized?
  before_filter :find_agency, :except => [:get_counties_for_states, :get_cities_for_counties, :get_zips_for_counties]
 

  def authorized?
    current_user.is_admin?
  end
  
  # GET /locations
  # GET /locations.xml
  def index
    redirect_to agencies_url
  end

  # GET /locations/1
  # GET /locations/1.xml
  def show
    redirect_to edit_agency_location_url(@location)
  end

  # GET /locations/new
  def new
    @location = Location.new
    @location.agency = @agency
    @new_restrictions = @location.get_empty_restrictions

    #set defaults
    @location.is_provider = true 
    @location.is_active = true 
    render :template => 'locations/edit'
  end

  # GET /locations/1;edit
  def edit
    @location = @agency.locations.find(params[:id])
    @new_restrictions = @location.get_empty_restrictions
  end

  # POST /locations
  # POST /locations.xml
  def create
    if params['cancel']
      redirect_to edit_agency_url(@agency) and return
    end
    params[:location][:new_plans] ||= []  # in case no checkboxes are checked
    params[:location][:plan_hq] ||= []  # in case no checkboxes are checked
    @location = @agency.locations.build(location_parameters)
    @location.updated_by = current_user.login
    @location.mailing_address = @location.build_mailing_address(mailing_address_parameters)
    @location.mailing_address.address_type='mailing'
    @location.dropin_address = @location.build_dropin_address(dropin_address_parameters)
    @location.dropin_address.address_type='dropin'

    update_pha_contact
    
    if @location.mailing_address.valid? and @location.dropin_address.valid? and @location.valid?
      @location.mailing_address.save 
      @location.dropin_address.save
      @location.update_restrictions(params)  
      @location.save
      flash[:notice] = 'Location was successfully created.'
      redirect_to edit_agency_url(@agency) and return if params['update_and_return']
      redirect_to agencies_path() and return if params['update_and_list']
      redirect_to edit_agency_location_url(:agency_id => @agency, :id => @location)
    else
      flash[:error] = "There was a problem trying to save your information."  # flash not being set by validations ????
      # setting object @new_restrictions in order to correct displaying partial _new_restriction_form.rhtml
      @new_restrictions = @location.get_empty_restrictions
      render :template => 'locations/edit' 
    end
  end

  # PUT /locations/1
  # PUT /locations/1.xml
  def update
    if params['cancel']
      redirect_to edit_agency_url(@agency) and return
    end
    params[:location][:new_plans] ||= []  # in case no checkboxes are checked
    params[:location][:plan_hq] ||= []  # in case no checkboxes are checked

    @location = @agency.locations.find(params[:id])
    @location.updated_by = current_user.login

    @location.build_mailing_address() if !@location.mailing_address
    @location.mailing_address.update_attributes(mailing_address_parameters)
    @location.mailing_address.address_type='mailing'

    @location.build_dropin_address() if !@location.dropin_address
    @location.dropin_address.update_attributes(dropin_address_parameters)
    @location.dropin_address.address_type='dropin'

    update_pha_contact
    @location.attributes = location_parameters

    if @location.mailing_address.valid? and @location.dropin_address.valid? and @location.valid?
      @location.mailing_address.save 
      @location.dropin_address.save
      @location.update_restrictions(params)
      @location.save
      flash[:notice] = 'Location was successfully updated.'
      redirect_to edit_agency_url(@agency) and return if params['update_and_return']
      redirect_to agencies_path() and return if params['update_and_list']
      redirect_to edit_agency_location_url(:agency_id => @agency, :id => @location)
    else
      flash[:error] = "There was a problem trying to save your information." # flash not being set by validations ????
      # setting object @new_restrictions in order to correct displaying partial _new_restriction_form.rhtml
      @new_restrictions = @location.get_empty_restrictions
      render :action => "edit" 
    end
  end

  # DELETE /locations/1
  # DELETE /locations/1.xml
  def destroy
    @location = @agency.locations.find(params[:id])
    @location.destroy

    respond_to do |format|
      format.html { redirect_to edit_agency_url(@agency) }
    end
  end
  
  protected
  
  def find_agency
    @agency = Agency.find(params[:agency_id])
  end
  
  def update_pha_contact
    @location.pha_contact = PhaContact.new(params[:pha_contact][:name], params[:pha_contact][:title],
      params[:pha_contact][:phone], params[:pha_contact][:email])
  end

  private

  def location_parameters
    params.require(:location).permit(:is_hq, :is_provider, :is_active, :name, :name2, :tollfree, :tollfree_ext, :phone,
                                     :phone_ext, :tty, :tty_ext, :fax, :url_title, :url, :url2_title, :url2, :email, :logistics,
                                     :hours_of_operation, :comment, plan_hq: [], new_plans: [], pha_contact: [:name,:title,:phone,:email],
                                     restriction_attr: [:id, :minimum_age, :age_restricted_phone, :max_poverty, :age_and_income, :special_district, :other_restrictions, :delete_marker])
  end

  def dropin_address_parameters
    params.require(:dropin_address).permit(:line1, :line2, :city, :state_abbrev, :plan_hq)
  end

  def mailing_address_parameters
    params.require(:mailing_address).permit(:line1, :line2, :city, :state_abbrev, :plan_hq)
  end
end
