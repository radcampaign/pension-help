class SearchController < ApplicationController
  def index
    @content = Content.find_by_url('search')
    render :template => "site/show_page.rhtml"
  end
end
