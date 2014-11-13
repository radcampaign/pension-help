class AgenciesController < ApplicationController
  before_filter :authenticate_user!, :authorized?, :except => :show

  def authorized?
    current_user.is_admin?
  end

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
    @locations = Location.joins(:dropin_address).where(agency_id: params[:id]).order(order)
    @plans = Plan.where(agency_id: params[:id]).order('position')
    #@agency.build_restriction if !@agency.restriction
  end

  # POST /agencies
  # POST /agencies.xml
  def create
    if params['cancel']
      redirect_to agencies_url and return
    end
    @agency = Agency.new(agencies_params)
    @agency.updated_by = current_user.login

    publication = Publication.new(publication_params)
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
      redirect_to agencies_url() and return if params['update_and_return']
      redirect_to edit_agency_url(@agency)
    else
      render :action => "new"
    end
  end

  # check if user clicked back button - if yes, set 'back' param to true
  # 'back' param is used for not to clear filter
  def go_to_agencies
    if params[:back]
      session[:back] = true
    else
      session[:back] = false
      redirect_to agencies_url(:clear=>true)
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
      @agency.publications[0].update_attributes(publication_params)
    else
      publication = Publication.new(publication_params)
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
      if @agency.update_attributes(agencies_params)
        flash[:notice] = 'Agency was successfully updated.'
        redirect_to agencies_url() and return if params['update_and_return']
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
    params[:plan_list].each_with_index { |id,idx| Plan.update(id, :position => idx) unless id.blank? }
    render :nothing => 'true'
  end

  def ajax_search

    session[:agency_order] = session[:agency_desc] = nil if (params[:clear] && session[:back]) # clear any params from session if this is our first time here
    params[:order] ||= session[:agency_order] # retrieve any existing params from the session
    params[:desc] ||= session[:agency_desc] unless params[:order] # don't override params[:desc] if we're passing in params[:order]
    session[:agency_order] = params[:order]   # save these params to session so they'll be 'remembered' on the next visit
    session[:agency_desc] = params[:desc]

    filter = find_search_filter
    filter.put_params(params, session[:back])

    params[:state_abbrevs] = filter.get_states
    params[:county_ids] = filter.get_counties
    params[:city_ids] = filter.get_cities
    params[:zip_ids] = filter.get_zips

    @selected_states = State.find_by_state_abbrevs(filter.get_states)
    @selected_counties = filter.get_counties.collect {|id| County.find(id)} if filter.get_counties
    filter.set_param('active', '1') unless filter.get_active
    filter.set_param('counseling', '1') unless filter.get_counseling
    params[:agency_category_id] = filter.get_category
    params[:counseling] = filter.get_counseling
    params[:active] = filter.get_active
    params[:provider] = filter.get_provider_type
    params[:agency_name] = filter.get_agency_name

    order = params[:order].nil? ? 'default' : params[:order]
    dir = params[:desc].nil? ? 1 : -1

    search_results = Agency.find_agencies filter
    @search_results = Agency.sort_agencies(search_results, order, dir)
  end

  def get_counties_for_states
    begin
      @states = params[:states].split(',').collect{|s| State.find_by_abbrev(s)}
    rescue ActiveRecord::RecordNotFound
      nil
    end
    @county_ids = params[:county_ids]
    render :partial => '/shared/counties', :locals => {:states => @states, :id_prefix => params[:id_prefix]}, :layout => false
  end

  def get_cities_for_counties
    begin
      @counties = params[:counties].split(',').collect{|c| County.find(c)} if (params[:counties] != nil)
    rescue ActiveRecord::RecordNotFound
      nil
    end
    @city_ids = params[:city_ids]
    render :partial => '/shared/cities', :locals => {:counties => @counties, :id_prefix => params[:id_prefix]}, :layout => false
  end

  def get_zips_for_counties
    begin
      @counties = params[:counties].split(',').collect{|c| County.find(c)} if (params[:counties]!=nil)
    rescue ActiveRecord::RecordNotFound
      nil
    end
    @zip_ids = params[:zip_ids]
    render :partial => '/shared/zips', :locals => {:counties => @counties, :id_prefix => params[:id_prefix]}, :layout => false
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
    'state' => 'COALESCE(NULLIF(addresses.state_abbrev, ""), "ZZZ"), locations.name'
  }
  def find_search_filter
    if (@SearchAreaFilter)
      @SearchAreaFilter = SearchAreaFilter.from_json(session[:search_filter])
    else
      @SearchAreaFilter = SearchAreaFilter.new
      session[:search_filter] = @SearchAreaFilter.as_json
    end
    @SearchAreaFilter
  end

  def agencies_params
    params.require(:agency).permit(:agency_category, :result_type, :is_active, :use_for_counseling, :name, :name2, :url_title, :url, :url2_title, :url2, :description, :comments)
  end

  def publication_params
    params.require(:publication).permit(:tollfree, :tollfree_ext, :phone, :phone_ext, :tty, :tty_ext, :fax, :url_title, :url, :email, pha_contact: [ :name, :title, :phone, :email])
  end
end