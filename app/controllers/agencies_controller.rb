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
    @categories = PlanCategory.find(:all)
    render 'agencies/edit'
  end

  # GET /agencies/1;edit
  def edit
    @agency = Agency.find(params[:id])
    @categories = PlanCategory.find(:all)
    @category = @agency.plan_category
    if @agency.plans
      @legacy_category = @agency.plans.collect{|plan| plan.legacy_category }.join("<br/>")
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
    @agency.plan_category = PlanCategory.find(params[:category])
    if @agency.update_attributes(params[:agency])
      flash[:notice] = 'Agency was successfully updated.'
      redirect_to agencies_url()
    else
      render :action => "edit"
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
    'plan' => 'if(agencies.plan_category_id is null or agencies.plan_category_id="", "9999", agencies.plan_category_id)',
    }
end
