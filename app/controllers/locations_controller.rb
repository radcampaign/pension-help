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
    @location = @agency.locations.build(params[:location])
    @location.updated_by = current_user.login
    @location.mailing_address = @location.build_mailing_address(params[:mailing_address])
    @location.mailing_address.address_type='mailing'
    @location.mailing_address.save!
    @location.dropin_address = @location.build_dropin_address(params[:dropin_address])
    @location.dropin_address.address_type='dropin'
    @location.dropin_address.save!
    @location.build_restriction if !@location.restriction
    update_restriction
    
    if @location.save
      flash[:notice] = 'Location was successfully created.'
      redirect_to edit_agency_url(@agency) 
    else
      render :action => "new" 
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
    if @location.mailing_address
      @location.mailing_address.update_attributes(params[:mailing_address])
    else
      @location.mailing_address = @location.build_mailing_address(params[:mailing_address])
      @location.mailing_address.address_type='mailing'
      @location.mailing_address.save!
    end
    if @location.dropin_address
      @location.dropin_address.update_attributes(params[:dropin_address])
    else
      @location.dropin_address = @location.build_dropin_address(params[:dropin_address])
      @location.dropin_address.address_type='dropin'
      @location.dropin_address.save!
    end  
    @location.build_restriction if !@location.restriction
    update_restriction
  
    if @location.update_attributes(params[:location])
      flash[:notice] = 'Location was successfully updated.'
      redirect_to edit_agency_url(@agency) 
    else
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
  
  def update_restriction
    @location.restriction.update_attributes(params[:restriction])
    @location.restriction.states=( params[:state_abbrevs].to_s.blank? ? [] : params[:state_abbrevs].collect{|s| State.find(s)} ) unless params[:state_abbrevs].nil?
    @location.restriction.counties = ( params[:county_ids].to_s.blank? ? [] : params[:county_ids].collect{|c| County.find(c)} ) unless params[:county_ids].nil?
    @location.restriction.counties=( params[:county_ids].to_s.blank? ? [] : params[:county_ids].collect{|c| County.find(c)} ) unless params[:county_ids].nil?
    @location.restriction.cities=( params[:city_ids].to_s.blank? ? [] : params[:city_ids].collect{|c| City.find(c)} ) unless params[:city_ids].nil?
    @location.restriction.zips=( params[:zip_ids].to_s.blank? ? [] : params[:zip_ids].collect{|c| Zip.find(c)} ) unless params[:zip_ids].nil?
  end
  
end
