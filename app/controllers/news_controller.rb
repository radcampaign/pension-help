class NewsController < ApplicationController  
  def index
    @internal_news = News.find(:all, :conditions => ["is_internal = 1", "publish_date < now()", "archive_date > now()"], :order => "publish_date desc", :limit => 3)
    @external_news = News.find(:all, :conditions => ["is_internal = 0", "publish_date < now()", "archive_date > now()"], :order => "publish_date desc", :limit => 3)
  end
  
  def external_news
    @external_news = News.find(:all, :conditions => ["is_internal = 0", "publish_date < now()", "archive_date > now()"], :order => "publish_date desc")
  end
end
