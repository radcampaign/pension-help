class Mailer < ActionMailer::Base
  
  def feedback(feedback)
    @recipients = EMAIL_RECIPIENT
    @from = EMAIL_FROM
    @sent_on = Time.now
    @subject = "PHA: Feedback [#{feedback.category}]"
    
    # Email body substitutions
    @body["type"] = feedback.category  
    @body["feedback"] = feedback.feedback
    @body["name"] = feedback.name
    @body["email"] = feedback.email
    @body["phone"] = feedback.phone
    @body["availability"] = feedback.availability
  end
  
  def search_net_application(partner)
    @recipients = EMAIL_RECIPIENT
    @from = EMAIL_FROM
    @sent_on = Time.now
    @subject = "PHA: PensionSearch Net Application"
    
    # Email body substitutions
    @body["partner"] = partner
  end
  
  def help_net_application(partner)
    @recipients = EMAIL_RECIPIENT
    @from = EMAIL_FROM
    @sent_on = Time.now
    @subject = "PHA: PensionHelp Net Application"
    
    # Email body substitutions
    @body["partner"] = partner
  end
  
  def npln_application(partner)
    @recipients = EMAIL_RECIPIENT
    @from = EMAIL_FROM
    @sent_on = Time.now
    @subject = "PHA: NPLN Application"
    
    # Email body substitutions
    @body["partner"] = partner
  end
  
  def aaa_application(partner)
    @recipients = EMAIL_RECIPIENT
    @from = EMAIL_FROM
    @sent_on = Time.now
    @subject = "PHA: PAL Application"
    
    # Email body substitutions
    @body["partner"] = partner
  end
  
  def page_email(email,site)
    @recipients = email.recipient_email
    @from = email.email
    @sent_on = Time.now
    @subject = "PensionHelp.org information"

    @body['mail'] = email
    @body['site'] = site
  end

  def user_application_confirmation(partner)
    @recipients = 'dan@freeportmetrics.com'
    @from = EMAIL_FROM
    @subject = "Thank for joining our nationwide pension assistance network"
    body["username"] = partner.user.login unless partner.user.nil?
  end
end
