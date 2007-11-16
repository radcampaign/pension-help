class LocationsController < ApplicationController
  before_filter :find_agency
  
  # GET /locations
  # GET /locations.xml
  def index
    @locations = @agency.locations.find(:all)

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @locations.to_xml }
    end
  end

  # GET /locations/1
  # GET /locations/1.xml
  def show
    @location = @agency.locations.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @location.to_xml }
    end
  end

  # GET /locations/new
  def new
    @location = Location.new
  end

  # GET /locations/1;edit
  def edit
    @location = @agency.locations.find(params[:id])
  end

  # POST /locations
  # POST /locations.xml
  def create
    @location = @agency.locations.build(params[:location])
    
    respond_to do |format|
      if @location.save
        flash[:notice] = 'Location was successfully created.'
        format.html { redirect_to location_url(@agency, @location) }
        format.xml  { head :created, :location => location_url(@agency, @location) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @location.errors.to_xml }
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
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @location.errors.to_xml }
      end
    end
  end

  # DELETE /locations/1
  # DELETE /locations/1.xml
  def destroy
    @location = @agency.locations.find(params[:id])
    @location.destroy

    respond_to do |format|
      format.html { redirect_to locations_url }
      format.xml  { head :ok }
    end
  end
  
  protected
  
  def find_agency
    @agency = Agency.find(params[:agency_id])
  end
end
