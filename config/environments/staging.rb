Rails.application.configure do

  # Code is not reloaded between requests.
  config.cache_classes = true

  # Eager load code on boot. This eager loads most of Rails and
  # your application in memory, allowing both threaded web servers
  # and those relying on copy on write to perform better.
  # Rake tasks automatically ignore this option for performance.
  config.eager_load = true

  # Full error reports are disabled and caching is turned on.
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Enable Rack::Cache to put a simple HTTP cache in front of your application
  # Add `rack-cache` to your Gemfile before enabling this.
  # For large-scale production use, consider using a caching reverse proxy like nginx, varnish or squid.
  # config.action_dispatch.rack_cache = true

  # Disable Rails's static asset server (Apache or nginx will already do this).
  config.serve_static_assets = false

  # Compress JavaScripts and CSS.
  config.assets.js_compressor = :uglifier
  # config.assets.css_compressor = :sass

  # Do not fallback to assets pipeline if a precompiled asset is missed.
  config.assets.compile = false

  # Generate digests for assets URLs.
  config.assets.digest = true

  # `config.assets.precompile` and `config.assets.version` have moved to config/initializers/assets.rb

  # Specifies the header that your server uses for sending files.
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # Eager load code on boot. This eager loads most of Rails and
  # your application in memory, allowing both threaded web servers
  # and those relying on copy on write to perform better.
  # Rake tasks automatically ignore this option for performance.
  config.eager_load = true

  # Set to :debug to see everything in the log.
  config.log_level = :debug

config.action_mailer.default_url_options = { :host => "qa.pensionhelp.org" }

ActionMailer::Base.smtp_settings = {
    :address => 'smtp.gmail.com',
    :domain => 'pensionhelp.org',
    :port => 587,
    :enable_starttls_auto => true,
    :authentication => :plain,
    :user_name => 'webmaster@pensionhelp.org',
    :password => 'pha:1021'
}

EMAIL_RECIPIENT = "alicja@freeportmetrics.com"
EMAIL_FROM = "alicja@freeportmetrics.com"
LINK_CHECKER_RECIPIENT = "alicja@freeportmetrics.com"
LINK_CHECKER_FROM = "alicja@freeportmetrics.com"

GA_ACCOUNT = '123TEST'
GA_EXPERIMENTS = '123TEST'

end