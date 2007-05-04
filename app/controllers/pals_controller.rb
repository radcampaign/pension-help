class PalsController < ApplicationController
  def index
    @content = Content.find_by_url('pals')
    render :template => "site/show_page.rhtml"
  end
end
