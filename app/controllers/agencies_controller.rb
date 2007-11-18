class AgenciesController < ApplicationController
  layout 'admin'
  
  # GET /agencies
  # GET /agencies.xml
  def index
    order = SORT_ORDER[params[:order]] if params[:order]
    order = 'agencies.name asc' unless order
    @agencies = Agency.find(:all, :include => [:dropin_addresses], :order => order)

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @agencies.to_xml }
    end
  end

  # GET /agencies/1
  # GET /agencies/1.xml
  def show
    @agency = Agency.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @agency.to_xml }
    end
  end

  # GET /agencies/new
  def new
    @agency = Agency.new
  end

  # GET /agencies/1;edit
  def edit
    @agency = Agency.find(params[:id])
  end

  # POST /agencies
  # POST /agencies.xml
  def create
    @agency = Agency.new(params[:agency])

    respond_to do |format|
      if @agency.save
        flash[:notice] = 'Agency was successfully created.'
        format.html { redirect_to agency_url(@agency) }
        format.xml  { head :created, :location => agency_url(@agency) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @agency.errors.to_xml }
      end
    end
  end

  # PUT /agencies/1
  # PUT /agencies/1.xml
  def update
    @agency = Agency.find(params[:id])

    respond_to do |format|
      if @agency.update_attributes(params[:agency])
        flash[:notice] = 'Agency was successfully updated.'
        format.html { redirect_to agencies_url() }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @agency.errors.to_xml }
      end
    end
  end

  # DELETE /agencies/1
  # DELETE /agencies/1.xml
  def destroy
    @agency = Agency.find(params[:id])
    @agency.destroy

    respond_to do |format|
      format.html { redirect_to agencies_url }
      format.xml  { head :ok }
    end
  end
  
  private
  SORT_ORDER = { 
    'name' => 'agencies.name',
    'state' => 'if(addresses.state_abbrev is null or addresses.state_abbrev="", "ZZZ", addresses.state_abbrev)',
    'plan' => 'if(agencies.plan_category_id is null or agencies.plan_category_id="", "9999", agencies.plan_category_id)',
    }
end
