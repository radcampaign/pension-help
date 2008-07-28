class NewsController < ApplicationController  

  def index
    # @scroll = true
    @internal_news = News.find(:all, :conditions => "is_internal = 1 AND publish_date <= current_date() AND archive_date > current_date()", :order => "position asc, publish_date desc")
    @external_news = News.find(:all, :conditions => "is_internal = 0 AND publish_date <= current_date() AND archive_date > current_date()", :order => "position asc, publish_date desc")
  end

  def external_news
    # @scroll = true
    @paginator, @external_news = paginate :news, :per_page => 10,
        :conditions => ["is_internal = 0 AND publish_date <= current_date() AND archive_date > current_date()"],
        :order => "position asc, publish_date desc"
  end

  def internal_news
    # @scroll = true
    @paginator, @internal_news = paginate :news, :per_page => 10,
        :conditions => "is_internal = 1 AND publish_date <= current_date() AND archive_date > current_date()",
        :order => "position asc, publish_date desc"
  end

  def internal
    @news = News.find_by_id_and_is_internal(params[:id], true)
  end
end
