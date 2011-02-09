config.cache_classes = true
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true
ActionMailer::Base.smtp_settings = { 
  :address => 'localhost',
  :domain  => 'pensionhelp.org'
}
EMAIL_RECIPIENT = "JHotz@PensionRights.org, dan@gradientblue.com"
EMAIL_FROM = "do-not-reply@PensionRights.org"