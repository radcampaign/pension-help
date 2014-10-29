Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Adds additional error checking when serving assets at runtime.
  # Checks for improperly declared sprockets dependencies.
  # Raises helpful error messages.
  config.assets.raise_runtime_errors = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # Don't care if the mailer can't send
  config.action_mailer.default_url_options = {
      :host => "localhost:3000",
  }

  require 'tlsmail'

  Net::SMTP.enable_tls(OpenSSL::SSL::VERIFY_NONE)
  config.action_mailer.raise_delivery_errors = true

  ActionMailer::Base.smtp_settings = {
      # :address => 'mail.pensionrights.org',
      # :domain  => 'pensionrights.org',
      # :port => 25,
      # :authentication => :plain,
      # :password => 'P@ssword1',
      # :user_name => 'noreply@pensionrights.org'
      :address => 'smtp.gmail.com',
      :domain  => 'pensionhelp.org',
      :port => 587,
      :authentication => :plain,
      :user_name => 'webmaster@pensionhelp.org',
      :password => 'pha:1021',
      :tls =>  true

  }


  EMAIL_RECIPIENT = "dan@freeportmetrics.com"
  EMAIL_FROM = "dan@freeportmetrics.com"
  LINK_CHECKER_RECIPIENT = "dan@freeportmetrics.com"
  LINK_CHECKER_FROM = "dan@freeportmetrics.com"

  GA_ACCOUNT = '123TEST'
  GA_EXPERIMENTS = '123TEST'
end
