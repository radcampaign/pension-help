class SearchController < ApplicationController
  def index
    @scroll = true
    @content = Content.find_by_url('search')
    render :template => "site/show_page.rhtml"
  end
 
  def method_missing(method, *args)
    @content = Content.find_by_url("search/#{method}")
    redirect_to '/404.html' and return unless @content
    render :template => "site/show_page.rhtml"
  end

  def search2
    @search_form = Search.new(params[:search_form])

    @results_freee = PhaMiner::ResultArray.new
    @results_pbgc = PhaMiner::ResultArray.new

    if request.post? && @search_form
      begin
        pbgc_miner = PhaMiner::PageMiners::PbgcMiner.new
        erisa_miner = PhaMiner::PageMiners::FreeErisaMiner.new

        @results_freee = erisa_miner.get_results(prepare_erisa_params(@search_form))
        @results_pbgc = pbgc_miner.get_results(prepare_pbgc_params(@search_form))
      rescue PhaMiner::Exceptions::HttpConnectionException => ex
        logger.error ex.to_s
      end
    end
  end

  private

  def prepare_pbgc_params(search_form)
    {
      'company1' => "#{search_form.company_name}",
      'state1' => "#{search_form.state}",
      'lname1' => '', 'commandAction' => 'companySearch1'
    }
  end
  
  def prepare_erisa_params(search_form)
    {
      'NewSearch' => 'Yes',
      #company name starts with/contains text
      'lstType' => '1',
      #company name
      'txtSearch' => "#{search_form.company_name}",
      #state
      'State' => "#{search_form.state}",
      #zip code, required if company's name length < 4 chars?
      'txtZIP' => "#{search_form.zip_code}",
      'submitFree.x' => '51',
      'submitFree.y' => '15',
      'submitFree' => 'search!',
      'defPlanType' => '1',
      'txtPension' => '',
      'txtPension' => '',
      'txtPension' => '',
      'defRegionType' => 'MSA',
      'txtRegion' => '',
      'txtRegion' => '',
      'txtRegion' => '',
      'Assets1' => '$',
      'Assets2' => '$',
      'Participants1' => '',
      'Participants2' => ''
    }
  end
end
