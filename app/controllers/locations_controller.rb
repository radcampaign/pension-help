class LocationsController < ApplicationController
  before_filter :login_required
  before_filter :find_agency, :except => :get_counties_for_states
  
  # GET /locations
  # GET /locations.xml
  def index
    redirect_to agencies_url
  end

  # GET /locations/1
  # GET /locations/1.xml
  def show
    redirect_to edit_agency_url(@agency) 
  end

  # GET /locations/new
  def new
    @location = Location.new
    render :partial => 'locations/location_detail', :layout => false
  end

  # GET /locations/1;edit
  def edit
    @location = @agency.locations.find(params[:id])
    render :partial => 'locations/location_detail', :layout => false
  end

  # POST /locations
  # POST /locations.xml
  def create
    @location = @agency.locations.build(params[:location])
    @location.mailing_address = @location.build_mailing_address(params[:mailing_address])
    @location.mailing_address.address_type='mailing'
    @location.mailing_address.save!
    @location.dropin_address = @location.build_dropin_address(params[:dropin_address])
    @location.dropin_address.address_type='dropin'
    @location.dropin_address.save!
    @location.states = params[:state_abbrevs].collect{|s| State.find(s)} unless params[:state_abbrevs].nil?
    @location.counties = params[:county_ids].collect{|c| County.find(c)} unless params[:county_ids].nil?

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
    @location = @agency.locations.find(params[:id])
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
    @location.states = params[:state_abbrevs].collect{|s| State.find(s)} unless params[:state_abbrevs].nil?
    @location.counties = params[:county_ids].collect{|c| County.find(c)} unless params[:county_ids].nil?
  
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

  def get_counties_for_states
    @states = params[:states].split(',').collect{|s| State.find_by_abbrev(s)}
    @county_ids = params[:county_ids]
    render :partial => '/shared/counties', :layout => false
  end
  
  protected
  
  def find_agency
    @agency = Agency.find(params[:agency_id])
  end
end
