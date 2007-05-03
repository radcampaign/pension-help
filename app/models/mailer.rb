class Mailer < ActionMailer::Base
  
  def feedback(name,email,phone,availability,type)
    @recipients = "support@golfbuzz.com"
    @from = email
    @sent_on = Time.now
    @subject = "PensionHelp Feedback"
    
    # Email body substitutions
    @body["name"] = name
    @body["email"] = email                       
    @body["phone"] = phone                          
    @body["availability"] = availability
    @body["type"] = type  
  end
  
  
end
