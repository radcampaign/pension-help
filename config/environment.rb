# Load the Rails application.
require File.expand_path('../application', __FILE__)

ADMIN_ROLE='ADMIN'
NETWORK_USER_ROLE='NETWORK_USER'

# employer type constants - corresponds to employer_types table
EMP_TYPE = {
  :company   => 1,
  :railroad  => 2,
  :religious => 3,
  :federal   => 4,
  :military  => 5,
  :state     => 6,
  :county    => 7,
  :city      => 8,
  :unknown   => 9,
  :farm_credit => 10
}


# Initialize the Rails application.
Rails.application.initialize!
