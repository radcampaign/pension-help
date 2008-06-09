class NewsController < ApplicationController  
  
  def index
    # @scroll = true
    @internal_news = News.find(:all, :conditions => "is_internal = 1 AND publish_date <= current_date() AND archive_date > current_date()", :order => "position asc, publish_date desc")
    @external_news = News.find(:all, :conditions => "is_internal = 0 AND publish_date <= current_date() AND archive_date > current_date()", :order => "position asc, publish_date desc")
  end
  
  def external_news
    # @scroll = true
    @external_news = News.find(:all, :conditions => "is_internal = 0 AND publish_date <= current_date() AND archive_date > current_date()", :order => "position asc, publish_date desc")
  end
end
