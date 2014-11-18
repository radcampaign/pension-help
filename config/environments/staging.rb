Rails.application.configure do

config.cache_classes = true
config.consider_all_requests_local = true
config.perform_caching = true
config.eager_load = true

# Set to :debug to see everything in the log.
config.log_level = :debug

config.action_mailer.default_url_options = { :host => "ec2-107-20-224-223.compute-1.amazonaws.com" }

ActionMailer::Base.smtp_settings = {
    :address => 'smtp.gmail.com',
    :domain => 'pensionhelp.org',
    :port => 587,
    :enable_starttls_auto => true,
    :authentication => :plain,
    :user_name => 'webmaster@pensionhelp.org',
    :password => 'pha:1021'
}

EMAIL_RECIPIENT = "jakub@freeportmetrics.com"
EMAIL_FROM = "jakub@freeportmetrics.com"
LINK_CHECKER_RECIPIENT = "jakub@freeportmetrics.com"
LINK_CHECKER_FROM = "jakub@freeportmetrics.com"

GA_ACCOUNT = '123TEST'
GA_EXPERIMENTS = '123TEST'

end