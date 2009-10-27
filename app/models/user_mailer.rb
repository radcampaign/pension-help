class UserMailer <  ActionMailer::Base

  def new_password(user, new_password)
    setup_email(user)
    @subject    += 'Your new password'
    @body[:new_password]  = new_password
  end

  protected

  def setup_email(user)
    @recipients  = "#{user.email}"
    @from        = "Support" "<admin@pensionhelp.com>"
    @subject     = ""
    @sent_on     = Time.now
    @body[:user] = user
  end
end