class UpdateNewsPositions < ActiveRecord::Migration
  def self.up
    @internal_news_pages = News.find(:all, :conditions => :is_internal, :order => 'position asc, publish_date desc')
    @external_news_pages = News.find(:all, :conditions => {:is_internal => false}, :order => 'position asc, publish_date desc')

    @internal_news_pages.each_with_index { |id,idx| News.update(id, :position => idx) unless id.blank? }
    @external_news_pages.each_with_index { |id,idx| News.update(id, :position => idx) unless id.blank? }
  end

  def self.down
  end
end
