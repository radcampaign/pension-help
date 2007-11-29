class AgenciesController < ApplicationController
  before_filter :login_required, :except => :show
  layout 'admin'
  
  # GET /agencies
  # GET /agencies.xml
  def index
    order = SORT_ORDER[params[:order]] if params[:order]
    order = 'agencies.name asc' unless order
    @agencies = Agency.find(:all, :include => [:dropin_addresses], :order => order, :group => 'agencies.id')

    # default render index.rhtml
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
    render 'agencies/edit'
  end

  # GET /agencies/1;edit
  def edit
    @agency = Agency.find(params[:id])
    if @agency.plans
    end
  end

  # POST /agencies
  # POST /agencies.xml
  def create
    @agency = Agency.new(params[:agency])

    if @agency.save
      flash[:notice] = 'Agency was successfully created.'
      redirect_to agency_url(@agency)
    else
      render :action => "new"
    end
  end

  # PUT /agencies/1
  # PUT /agencies/1.xml
  def update
    @agency = Agency.find(params[:id])
    if @agency.publication
      @agency.publications[0].update_attributes(params[:publication])
    else
      @agency.publications[0] = @agency.build_publication(params[:publication])
      @agency.publications[0].save!
    end    
    begin
      if @agency.update_attributes(params[:agency])
        flash[:notice] = 'Agency was successfully updated.'
        redirect_to agencies_url()
      else
        render :action => "edit"
      end 
    end
  end

  # DELETE /agencies/1
  # DELETE /agencies/1.xml
  def destroy
    @agency = Agency.find(params[:id])
    @agency.destroy
    redirect_to agencies_url
  end
  
  private
  
  SORT_ORDER = { 
    'name' => 'agencies.name',
    'state' => 'if(addresses.state_abbrev is null or addresses.state_abbrev="", "ZZZ", addresses.state_abbrev)',
    'category' => 'if(agencies.agency_category_id is null or agencies.agency_category_id="", "9999", agencies.agency_category_id)',
    'result' => 'if(agencies.result_type_id is null or agencies.result_type_id="", "9999", agencies.result_type_id)'
    }
end
