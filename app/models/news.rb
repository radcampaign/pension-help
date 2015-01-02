# == Schema Information
#
# Table name: news
#
#  id           :integer          not null, primary key
#  title        :string(255)
#  intro        :text
#  article_url  :string(255)
#  source_url   :string(255)
#  is_internal  :boolean
#  body         :text
#  publish_date :date
#  archive_date :date
#  created_at   :datetime
#  updated_at   :datetime
#  updated_by   :string(255)
#  position     :integer
#

class News < ActiveRecord::Base
  
  def is_active?
    publish_date <= d=Date.today and archive_date >= d
  end
  
end
