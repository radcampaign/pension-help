class HelpController < ApplicationController
  def index
    @content = Content.find_by_url('help')
    render :template => "site/show_page.rhtml"
  end
end
