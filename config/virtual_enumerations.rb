# Copyright (c) 2005 Trevor Squires
# Released under the MIT License.  See the LICENSE file for more details.

# Copy this file to RAILS_ROOT/config/virtual_enumerations.rb
# and configure it accordingly.
ActiveRecord::VirtualEnumerations.define do |config|
  config.define [:agency_category,
                 :result_type,
                 :profession,
                 :sponsor_type,
                 :plan_type,
                 :referral_fee,
                 :claim_type,
                 :npln_additional_area,
                 :npln_participation_level,
                 :pal_additional_area,
                 :pal_participation_level,
                 :search_plan_type,
                 :help_additional_area,
                 :pension_earner,
                 :employer_type,
                 :federal_plan,
                 :military_service,
                 :military_branch,
                 :military_employer,
                 :jurisdiction,
                 :geo_area
                 ], :order => 'position ASC'
end
