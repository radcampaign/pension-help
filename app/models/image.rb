class Image < ActiveRecord::Base
  has_attachment :storage => :file_system, :path_prefix => 'public/files',
                 :thumbnails => { :thumb => [80, 80] }
end
