# == Schema Information
# Schema version: 41
#
# Table name: news
#
#  id           :integer(11)   not null, primary key
#  title        :string(255)   
#  intro        :text          
#  article_url  :string(255)   
#  source_url   :string(255)   
#  is_internal  :boolean(1)    
#  body         :text          
#  publish_date :date          
#  archive_date :date          
#  created_at   :datetime      
#  updated_at   :datetime      
#  updated_by   :string(255)   
#  position     :integer(11)   
#

class News < ActiveRecord::Base
end
