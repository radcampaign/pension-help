class NewsController < ApplicationController  
  
  def index
    @scroll = true
    @internal_news = News.find(:all, :conditions => ["is_internal = 1", "publish_date < now()", "archive_date > now()"], :order => "position asc, publish_date desc", :limit => 3)
    @external_news = News.find(:all, :conditions => ["is_internal = 0", "publish_date < now()", "archive_date > now()"], :order => "position asc, publish_date desc", :limit => 3)
  end
  
  def external_news
    @scroll = true
    @external_news = News.find(:all, :conditions => ["is_internal = 0", "publish_date < now()", "archive_date > now()"], :order => "position asc, publish_date desc")
  end
end
