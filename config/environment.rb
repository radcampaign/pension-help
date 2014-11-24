# Load the Rails application.
require File.expand_path('../application', __FILE__)

if !Rails.env.development?
Rails.application.config.middleware.use ExceptionNotification::Rack,
                           :email => {
                               :email_prefix => "[PHA ERROR] ",
                               :sender_address => %("PHA Application Error" <do_not_reply@freeportmetrics.com>),
                               :exception_recipients => %w(jakub@freeportmetrics.com matuszewski@freeportmetrics.com alicja@freeportmetrics.com dan@freeportmetrics.com)
                           }
end

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
