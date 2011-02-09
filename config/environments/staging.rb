config.cache_classes = true
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true
require 'tlsmail'

Net::SMTP.enable_tls(OpenSSL::SSL::VERIFY_NONE)

ActionMailer::Base.smtp_settings = {
  :address => 'smtp.gmail.com',
  :domain  => 'gmail.com',
  :port => 587,
  :authentication => :plain,
  :user_name => 'pensionhelpamerica@gmail.com',
  :password => 'gblue2011',
  :tls =>  true

}

EMAIL_RECIPIENT = "dan@freeportmetrics.com, marcin@freeportmetrics.com"
EMAIL_FROM = "do-not-reply@PensionRights.org"