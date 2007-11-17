class LocationsController < ApplicationController
  before_filter :find_agency
  
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
    
    respond_to do |format|
      if @location.save
        flash[:notice] = 'Location was successfully created.'
        format.html { redirect_to edit_agency_url(@agency) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /locations/1
  # PUT /locations/1.xml
  def update
    @location = @agency.locations.find(params[:id])

    respond_to do |format|
      if @location.update_attributes(params[:location])
        flash[:notice] = 'Location was successfully updated.'
        format.html { redirect_to edit_agency_url(@agency) }
      else
        format.html { render :action => "edit" }
      end
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
end
