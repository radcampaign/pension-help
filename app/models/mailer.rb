class Mailer < ActionMailer::Base
  
  EMAIL_RECIPIENT = "pha@gradientblue.com"
  EMAIL_FROM = "pha@gradientblue.com"
  
  def feedback(type,feedback,name=nil,email=nil,phone=nil,availability=nil)
    @recipients = EMAIL_RECIPIENT
    @from = EMAIL_FROM
    @sent_on = Time.now
    @subject = "PHA: Feedback [#{type}]"
    
    # Email body substitutions
    @body["type"] = type  
    @body["feedback"] = feedback  
    @body["name"] = name
    @body["email"] = email                       
    @body["phone"] = phone                          
    @body["availability"] = availability
  end
  
  def search_net_application(contact,seach_net)
    @recipients = EMAIL_RECIPIENT
    @from = EMAIL_FROM
    @sent_on = Time.now
    @subject = "PHA: PensionSearch Net Application"
    
    # Email body substitutions
    @body["contact"] = contact
    @body["seach_net"] = seach_net
  end
  
  def help_net_application(contact,help_net)
    @recipients = EMAIL_RECIPIENT
    @from = EMAIL_FROM
    @sent_on = Time.now
    @subject = "PHA: PensionHelp Net Application"
    
    # Email body substitutions
    @body["contact"] = contact
    @body["help_net"] = help_net
  end
  
  def npln_application(contact)
    @recipients = EMAIL_RECIPIENT
    @from = EMAIL_FROM
    @sent_on = Time.now
    @subject = "PHA: NPLN Application"
    
    # Email body substitutions
    @body["contact"] = contact
  end
  
  def aaa_application(contact)
    @recipients = EMAIL_RECIPIENT
    @from = EMAIL_FROM
    @sent_on = Time.now
    @subject = "PHA: PAL Application"
    
    # Email body substitutions
    @body["contact"] = contact
  end
  
end
