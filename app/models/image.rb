# == Schema Information
#
# Table name: images
#
#  id           :integer          not null, primary key
#  parent_id    :integer
#  thumbnail    :string(255)
#  filename     :string(255)
#  content_type :string(255)
#  size         :integer
#  width        :integer
#  height       :integer
#  aspect_ratio :float(24)
#

class Image < ActiveRecord::Base
  has_attachment :storage => :file_system, :path_prefix => 'public/files',
                 :thumbnails => { :thumb => [80, 80] }
end
