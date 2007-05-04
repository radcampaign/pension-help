class Contact < ActiveRecord::Base
  has_one :help_net, :dependent => :destroy
  has_one :search_net, :dependent => :destroy
  has_one :profession, :dependent => :destroy
end
