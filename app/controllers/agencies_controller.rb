class AgenciesController < ApplicationController
  before_filter :login_required, :except => :show
  layout 'admin'
  
  # GET /agencies
  # GET /agencies.xml
  def index
    order = SORT_ORDER[params[:order]] if params[:order]
    order = 'if(agencies.agency_category_id is null or agencies.agency_category_id="", "9999", agencies.agency_category_id), if(addresses.state_abbrev is null or addresses.state_abbrev="", "ZZZ", addresses.state_abbrev), agencies.name asc' unless order
    @agencies = Agency.find(:all, :include => [:dropin_addresses], :order => order, :group => 'agencies.id')

    # default render index.rhtml
  end

  # GET /agencies/1
  # GET /agencies/1.xml
  def show
    @agency = Agency.find(params[:id])
    redirect_to edit_agency_url(@agency)
  end

  # GET /agencies/new
  def new
    @agency = Agency.new
    @agency.build_restriction
    @agency.publications.build
    render 'agencies/edit'
  end

  # GET /agencies/1;edit
  def edit
    @agency = Agency.find(params[:id])
    @agency.build_restriction if !@agency.restriction
  end

  # POST /agencies
  # POST /agencies.xml
  def create
    @agency = Agency.new(params[:agency])
    @agency.publications[0] = @agency.publications.build(params[:publication])
    @agency.build_restriction
    @agency.restriction.update_attributes(params[:restriction])
    @agency.restriction.states=params[:state_abbrevs].collect{|s| State.find(s)} unless params[:state_abbrevs].to_s.blank?
    @agency.restriction.counties=params[:county_ids].collect{|c| County.find(c)} unless params[:county_ids].nil?
    @agency.restriction.cities=params[:city_ids].collect{|c| City.find(c)} unless params[:city_ids].nil?
    @agency.restriction.zips=params[:zip_ids].collect{|c| Zip.find(c)} unless params[:zip_ids].nil?
    if @agency.save
      flash[:notice] = 'Agency was successfully created.'
      redirect_to edit_agency_url(@agency)
    else
      render :action => "new"
    end
  end

  # PUT /agencies/1
  # PUT /agencies/1.xml
  def update
    if params['cancel']
      redirect_to agencies_url and return
    end
    @agency = Agency.find(params[:id])
    if @agency.publication
      @agency.publications[0].update_attributes(params[:publication])
    else
      @agency.publications[0] = @agency.publications.build(params[:publication])
      @agency.publications[0].save!
    end
    @agency.build_restriction if !@agency.restriction
      
    @agency.restriction.update_attributes(params[:restriction])
    @agency.restriction.states=params[:state_abbrevs].collect{|s| State.find(s)} unless params[:state_abbrevs].to_s.blank?
    @agency.restriction.counties=params[:county_ids].collect{|c| County.find(c)} unless params[:county_ids].nil?
    @agency.restriction.cities=params[:city_ids].collect{|c| City.find(c)} unless params[:city_ids].nil?
    @agency.restriction.zips=params[:zip_ids].collect{|c| Zip.find(c)} unless params[:zip_ids].nil?
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
  
  def switch_counseling
    if (agency=Agency.find(params[:id]))
      agency.update_attribute(:use_for_counseling, !agency.use_for_counseling)
    end
    render :partial => 'agencies/counseling_check', :layout => false, :locals => {:agency => agency}
  end

  def switch_active
    if (agency=Agency.find(params[:id]))
      agency.update_attribute(:is_active, !agency.is_active)
    end
    render :partial => 'agencies/active_check', :layout => false, :locals => {:agency => agency}
  end

  private
  
  # peculiar category order due to TRAC #82 (https://prc.gradientblue.com/trac/pha/ticket/82)
  SORT_ORDER = { 
    'name' => 'agencies.name',
    'state' => 'if(addresses.state_abbrev is null or addresses.state_abbrev="", "ZZZ", addresses.state_abbrev)',
    'category' => 'if(agencies.agency_category_id is null or agencies.agency_category_id="", "9999", agencies.agency_category_id), if(addresses.state_abbrev is null or addresses.state_abbrev="", "ZZZ", addresses.state_abbrev), agencies.name',
    'result' => 'if(agencies.result_type_id is null or agencies.result_type_id="", "9999", agencies.result_type_id)',
    'counseling' => 'agencies.use_for_counseling',
    'active' => 'agencies.is_active'
    }
end
