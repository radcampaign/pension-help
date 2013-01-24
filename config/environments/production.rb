# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host                  = "http://assets.example.com"

# Disable delivery errors, bad email addresses will be ignored
# config.action_mailer.raise_delivery_errors = false
require 'tlsmail'

config.action_mailer.default_url_options = {
  :host => "www.pensionhelp.org",
}

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

EMAIL_RECIPIENT = "pensionhelp@pensionrights.org"
EMAIL_FROM = "webmaster@pensionhelp.org"
LINK_CHECKER_RECIPIENT = "dan@freeportmetrics.com, pensionhelp@pensionrights.org"
LINK_CHECKER_FROM = "webmaster@pensionhelp.org"
