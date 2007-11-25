# Copyright (c) 2005 Trevor Squires
# Released under the MIT License.  See the LICENSE file for more details.

# Copy this file to RAILS_ROOT/config/virtual_enumerations.rb
# and configure it accordingly.
ActiveRecord::VirtualEnumerations.define do |config|
  config.define [:agency_category], :order => 'position ASC'
  config.define [:result_type], :order => 'position ASC'
end
