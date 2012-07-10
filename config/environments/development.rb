# Settings specified here will take precedence over those in config/environment.rb

# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
config.cache_classes = false

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Enable the breakpoint server that script/breakpointer connects to
config.breakpoint_server = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_controller.perform_caching             = false
config.action_view.cache_template_extensions         = false
config.action_view.debug_rjs                         = true

config.action_mailer.default_url_options = {
  :host => "localhost:3000",
}

# Don't care if the mailer can't send
require 'tlsmail'

Net::SMTP.enable_tls(OpenSSL::SSL::VERIFY_NONE)
config.action_mailer.raise_delivery_errors = true

ActionMailer::Base.smtp_settings = {
  # :address => 'mail.pensionrights.org',
  # :domain  => 'pensionrights.org',
  # :port => 25,
  # :authentication => :none
  :address => 'smtp.gmail.com',
  :domain  => 'gmail.com',
  :port => 587,
  :authentication => :plain,
  :user_name => 'pensionhelpamerica@gmail.com',
  :password => 'gblue2011',
  :tls =>  true

}


  EMAIL_RECIPIENT = "dan@gradientblue.com, dan@piltch.com"
  EMAIL_FROM = "dan@gradientblue.com"
  LINK_CHECKER_RECIPIENT = "dan@gradientblue.com, dan@piltch.com, filip@freeportmetrics.com"
  LINK_CHECKER_FROM = "dan@gradientblue.com"
  # LINK_CHECKER_RECIPIENT = "filip@freeportmetrics.com"
  # LINK_CHECKER_FROM = "filip@freeportmetrics.com"

# require "ruby-debug"