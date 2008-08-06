class AgenciesController < ApplicationController
  before_filter :login_required, :except => :show
  layout 'admin'
  
  def authorized?
    current_user.is_admin?
  end

  # GET /agencies
  # GET /agencies.xml
  def index
    @restriction = Restriction.new

    ajax_search

    render :action => :area_served_search

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
    #set default values
    @agency.is_active=true
    @agency.use_for_counseling=true
    render 'agencies/edit'
  end

  # GET /agencies/1;edit
  def edit
    order = SORT_ORDER_LOC[params[:order]] if params[:order]
    @agency = Agency.find(params[:id])
    @locations = Location.find_all_by_agency_id(params[:id], :include => [:dropin_address], :order => order)
    #@agency.build_restriction if !@agency.restriction
  end

  # POST /agencies
  # POST /agencies.xml
  def create
    if params['cancel']
      redirect_to agencies_url and return
    end
    @agency = Agency.new(params[:agency])
    @agency.updated_by = current_user.login
    
    publication = Publication.new(params[:publication])
    @agency.publications << publication unless publication.empty?

    #@agency.build_restriction
    #@agency.restriction.update_attributes(params[:restriction])
    #@agency.restriction.states=params[:state_abbrevs].collect{|s| State.find(s)} unless params[:state_abbrevs].to_s.blank?
    #@agency.restriction.counties=params[:county_ids].collect{|c| County.find(c)} unless params[:county_ids].nil?
    #@agency.restriction.cities=params[:city_ids].collect{|c| City.find(c)} unless params[:city_ids].nil?
    #@agency.restriction.zips=params[:zip_ids].collect{|c| Zip.find(c)} unless params[:zip_ids].nil?
    
    #composed_of fields must be created manually
    update_pha_contact

    if @agency.save
      flash[:notice] = 'Agency was successfully created.'
      redirect_to agencies_url() and return if @params['update_and_return']
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
    @agency.updated_by = current_user.login
    if @agency.publication
      @agency.publications[0].update_attributes(params[:publication])
    else
      publication = Publication.new(params[:publication])
      unless publication.empty?
        @agency.publications << publication
        @agency.publications.last.save!
      end
    end
#    @agency.build_restriction if !@agency.restriction
#
#    @agency.restriction.update_attributes(params[:restriction])
#    @agency.restriction.states=params[:state_abbrevs].collect{|s| State.find(s)} unless params[:state_abbrevs].to_s.blank?
#    @agency.restriction.counties=params[:county_ids].collect{|c| County.find(c)} unless params[:county_ids].nil?
#    @agency.restriction.cities=params[:city_ids].collect{|c| City.find(c)} unless params[:city_ids].nil?
#    @agency.restriction.zips=params[:zip_ids].collect{|c| Zip.find(c)} unless params[:zip_ids].nil?

    #composed_of fields must be created manually
    update_pha_contact

    begin
      if @agency.update_attributes(params[:agency])
        flash[:notice] = 'Agency was successfully updated.'
        redirect_to agencies_url() and return if @params['update_and_return']
        redirect_to edit_agency_url(@agency)
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

  def sort_location
    params[:location_list].each_with_index { |id,idx| Location.update(id, :position => idx) }
    render :nothing => 'true'
  end

  def sort_plan
    params[:plan_list].each_with_index { |id,idx| Plan.update(id, :position => idx) }
    render :nothing => 'true'
  end
  
  def ajax_search

    #params[:clear] =     session[:agency_order] = session[:agency_desc] = nil if params[:clear] # clear any params from session if this is our first time here
    session[:agency_order] = session[:agency_desc] = nil if params[:clear] # clear any params from session if this is our first time here
    params[:order] ||= session[:agency_order] # retrieve any existing params from the session
    params[:desc] ||= session[:agency_desc] unless params[:order] # don't override params[:desc] if we're passing in params[:order] 
    session[:agency_order] = params[:order]   # save these params to session so they'll be 'remembered' on the next visit
    session[:agency_desc] = params[:desc]

    filter = find_search_filter
    filter.put_params(params)
    params[:state_abbrevs] = filter.get_states
    params[:county_ids] = filter.get_counties
    params[:city_ids] = filter.get_cities
    params[:zip_ids] = filter.get_zips

    @selected_states = State.find_by_state_abbrevs(filter.get_states)
    @selected_counties = filter.get_counties.collect {|id| County.find(id)} if filter.get_counties
    params[:agency_category_id] = filter.get_category
    params[:counseling] = filter.get_counseling
    params[:active] = filter.get_active
    params[:provider] = filter.get_provider_type

    order = params[:order].nil? ? 'default' : params[:order]
    dir = params[:desc].nil? ? 1 : -1

    search_results = Agency.find_agencies filter
    @search_results = Agency.sort_agencies(search_results, order, dir)

  end

  private
  def update_pha_contact
    @agency.pha_contact = PhaContact.new(params[:pha_contact][:name], params[:pha_contact][:title],
      params[:pha_contact][:phone], params[:pha_contact][:email])
  end

  # peculiar category order due to TRAC #82 (https://prc.gradientblue.com/trac/pha/ticket/82)
#  CATEGORY_SORT = 'if(agencies.agency_category_id is null or agencies.agency_category_id="", "9999", agencies.agency_category_id)'
#  STATE_SORT = 'if(addresses.state_abbrev is null or addresses.state_abbrev="", "ZZZ", addresses.state_abbrev)'
#  RESULT_SORT = 'if(agencies.result_type_id is null or agencies.result_type_id="", "9999", agencies.result_type_id)'
  
#  SORT_ORDER = { 
#    'default' => CATEGORY_SORT + ', ' + STATE_SORT + ', agencies.name asc',
#    'name' => 'agencies.name',
#    'state' => STATE_SORT + ', agencies.name',
#    'category' => CATEGORY_SORT + ', ' + STATE_SORT + ', agencies.name',
#    'result' => RESULT_SORT + ', agencies.name',
#    'counseling' => 'agencies.use_for_counseling desc, ' + CATEGORY_SORT + ', agencies.name',
#    'active' => 'agencies.is_active desc, ' + CATEGORY_SORT + ', agencies.name',
#    'name_desc' => 'agencies.name desc',
#    'state_desc' => STATE_SORT + ' desc , agencies.name',
#    'category_desc' => CATEGORY_SORT + ' desc , ' + STATE_SORT + ', agencies.name',
#    'result_desc' => RESULT_SORT + ' desc , agencies.name',
#    'counseling_desc' => 'agencies.use_for_counseling asc, ' + CATEGORY_SORT + ', agencies.name',
#    'active_desc' => 'agencies.is_active asc, ' + CATEGORY_SORT + ', agencies.name',
#    'provider' => CATEGORY_SORT + ', ' + STATE_SORT + ', agencies.name asc'
    #commenting out changes below pending ticket #211
    #client doesn't want to implement partial fixes for #211 until all the sorting is complete
    # 'default' => CATEGORY_SORT + ', ' + STATE_SORT + ', agencies.name asc',
    # 'name' => 'agencies.name',
    # 'state' => STATE_SORT + ', ' + CATEGORY_SORT + ', ' + RESULT_SORT + ', agencies.name',
    # 'category' => CATEGORY_SORT + ', ' + RESULT_SORT + ', agencies.name',
    # 'result' => RESULT_SORT + ', ' + CATEGORY_SORT  + ', agencies.name',
    # 'counseling' => 'agencies.use_for_counseling desc, ' + CATEGORY_SORT + ' desc , ' + RESULT_SORT + ', agencies.name',
    # 'active' => 'agencies.is_active desc, ' + 'agencies.use_for_counseling desc, ' + CATEGORY_SORT + ' desc , ' + RESULT_SORT + ', agencies.name',
    # 'name_desc' => 'agencies.name desc',
    # 'state_desc' => STATE_SORT + 'desc , ' + CATEGORY_SORT + ', ' + RESULT_SORT + ',  agencies.name',
    # 'category_desc' => CATEGORY_SORT + ' desc , ' + RESULT_SORT + ', agencies.name',
    # 'result_desc' => RESULT_SORT + 'desc , ' + CATEGORY_SORT  + ', agencies.name',
    # 'counseling_desc' => 'agencies.use_for_counseling asc, ' + CATEGORY_SORT + ' desc , ' + RESULT_SORT + ', agencies.name',
    # 'active_desc' => 'agencies.is_active asc, ' + 'agencies.use_for_counseling desc, ' + CATEGORY_SORT + ' desc , ' + RESULT_SORT + ', agencies.name',
    # 'provider' => 'agencies.use_for_counseling desc, ' + CATEGORY_SORT + ' desc , ' + RESULT_SORT + ', agencies.name',
#  }
    
  SORT_ORDER_LOC = {
    'name' => 'locations.name',
    'state' => 'if(addresses.state_abbrev is null or addresses.state_abbrev="", "ZZZ", addresses.state_abbrev), locations.name'
  }
  def find_search_filter
    session['search_filter'] = SearchAreaFilter.new unless session['search_filter']
    session['search_filter']
  end
end