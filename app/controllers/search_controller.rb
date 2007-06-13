class SearchController < ApplicationController
  def index
    @scroll = true
    @content = Content.find_by_url('search')
    render :template => "site/show_page.rhtml"
  end
  
  def pbgc
    @content = Content.find_by_url('search/pbgc')
    render :template => "site/show_page.rhtml"
  end

  def free_erisa
    @content = Content.find_by_url('search/free_erisa')
    render :template => "site/show_page.rhtml"
  end

  def corporate_affiliations
    @content = Content.find_by_url('search/corporate_affiliations')
    render :template => "site/show_page.rhtml"
  end
  
  def pension_booklet
    @content = Content.find_by_url('search/pension_booklet')
    render :template => "site/show_page.rhtml"
  end
end
