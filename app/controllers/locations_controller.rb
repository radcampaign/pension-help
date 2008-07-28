class LocationsController < ApplicationController
  before_filter :login_required
  before_filter :find_agency, :except => [:get_counties_for_states, :get_cities_for_counties, :get_zips_for_counties]
  layout 'admin'
  
  # GET /locations
  # GET /locations.xml
  def index
    redirect_to agencies_url
  end

  # GET /locations/1
  # GET /locations/1.xml
  def show
    redirect_to edit_location_url(@location) 
  end

  # GET /locations/new
  def new
    @location = Location.new
    @location.build_restriction
    #set defaults
    @location.is_provider = true 
    @location.is_active = true 
    render :template => 'locations/edit'
    #render :partial => 'locations/location_detail', :layout => false
  end

  # GET /locations/1;edit
  def edit
    @location = @agency.locations.find(params[:id])
    @location.build_restriction if !@location.restriction
    #render :partial => 'locations/location_detail', :layout => false
  end

  # POST /locations
  # POST /locations.xml
  def create
    if @params['cancel']
      redirect_to edit_agency_url(@agency) and return
    end
      @location = @agency.locations.build(params[:location])
    @location.updated_by = current_user.login
    @location.mailing_address = @location.build_mailing_address(params[:mailing_address])
    @location.mailing_address.address_type='mailing'
    @location.dropin_address = @location.build_dropin_address(params[:dropin_address])
    @location.dropin_address.address_type='dropin'
    @location.restriction = Restriction.create_restriction params

    update_pha_contact

    #validate restriction only when restriction is notn null
    restriction_valid = true
    restriction_valid = @location.restriction.valid? if @location.restriction

    if @location.mailing_address.valid? and @location.dropin_address.valid? and restriction_valid and @location.valid?
      @location.mailing_address.save
      @location.dropin_address.save
      @location.restriction.save if @location.restriction
      @location.save
      flash[:notice] = 'Location was successfully created.'
      redirect_to edit_agency_url(@agency) and return if @params['update_and_return']
      redirect_to agencies_path() and return if params['update_and_list']
      redirect_to edit_location_url(:agency_id => @agency, :id => @location)
    else
      flash[:error] = "There was a problem trying to save your information."  # flash not being set by validations ????
      render :template => 'locations/edit' 
    end
  end

  # PUT /locations/1
  # PUT /locations/1.xml
  def update
    if @params['cancel']
      redirect_to edit_agency_url(@agency) and return
    end
    @location = @agency.locations.find(params[:id])
    @location.updated_by = current_user.login

    @location.build_mailing_address() if !@location.mailing_address
    @location.mailing_address.attributes = params[:mailing_address]
    @location.mailing_address.address_type='mailing'

    @location.build_dropin_address() if !@location.dropin_address
    @location.dropin_address.attributes = params[:dropin_address]
    @location.dropin_address.address_type='dropin'

    if @location.restriction
      @location.restriction.update_restriction params
    else
      @location.restriction = Restriction.create_restriction params
    end
    
    update_pha_contact
    @location.attributes = params[:location]

    #validate restriction only when restriction is notn null
    restriction_valid = true
    restriction_valid = @location.restriction.valid? if @location.restriction

    if @location.mailing_address.valid? and @location.dropin_address.valid? and
        restriction_valid and @location.valid?
      @location.mailing_address.save 
      @location.dropin_address.save
      @location.restriction.save if @location.restriction
      @location.save
      flash[:notice] = 'Location was successfully updated.'
      redirect_to edit_agency_url(@agency) and return if @params['update_and_return']
      redirect_to agencies_path() and return if params['update_and_list']
      redirect_to edit_location_url(:agency_id => @agency, :id => @location)
    else
      flash[:error] = "There was a problem trying to save your information." # flash not being set by validations ????
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
end
