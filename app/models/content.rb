# == Schema Information
# Schema version: 41
#
# Table name: contents
#
#  id         :integer(11)   not null, primary key
#  url        :string(255)   
#  title      :string(255)   
#  content    :text          
#  created_at :string(255)   
#  updated_at :datetime      
#  updated_by :string(255)   
#

class Content < ActiveRecord::Base
  acts_as_nested_set
  
  #Returns list of contents, ommits element with given id
  def Content.get_content_list(content_id = nil)
    Content.root.full_set.collect{|elem| elem unless (content_id && elem.id == content_id) }.compact
  end

  def show_sidebar?(url)
    return true if sidebar_urls.include?(url.to_s)
    false
  end

  def sidebar_urls
    %w(/ about_us terms_of_use)
  end


end
