config.cache_classes = true
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true
require 'tlsmail'

config.action_mailer.default_url_options = { :host => "qa.pensionhelp.org" }

Net::SMTP.enable_tls(OpenSSL::SSL::VERIFY_NONE)

ActionMailer::Base.smtp_settings = {
  :address => 'smtp.gmail.com',
  :domain  => 'pensionhelp.org',
  :port => 587,
  :authentication => :plain,
  :user_name => 'webmaster@pensionhelp.org',
  :password => 'pha:1021',
  :tls =>  true

}

EMAIL_RECIPIENT = "dan@freeportmetrics.com"
EMAIL_FROM = "webmaster@pensionhelp.org"
LINK_CHECKER_RECIPIENT = "dan@freeportmetrics.com, jleavelle@pensionrights.org"
LINK_CHECKER_FROM = "webmaster@pensionhelp.org"
