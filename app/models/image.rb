# == Schema Information
# Schema version: 41
#
# Table name: images
#
#  id           :integer(11)   not null, primary key
#  parent_id    :integer(11)   
#  thumbnail    :string(255)   
#  filename     :string(255)   
#  content_type :string(255)   
#  size         :integer(11)   
#  width        :integer(11)   
#  height       :integer(11)   
#  aspect_ratio :float         
#

class Image < ActiveRecord::Base
  has_attachment :storage => :file_system, :path_prefix => 'public/files',
                 :thumbnails => { :thumb => [80, 80] }
end
