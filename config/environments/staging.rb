config.cache_classes = true
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true
require 'tlsmail'

config.action_mailer.default_url_options = { :host => "qa.pensionhelp.org" }

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

EMAIL_RECIPIENT = "dan@gradientblue.com"
EMAIL_FROM = "do-not-reply@PensionRights.org"
LINK_CHECKER_RECIPIENT = "dan@gradientblue.com,jleavelle@pensionrights.org"
LINK_CHECKER_FROM = "do-not-reply@PensionRights.org"
