class Mailer < ActionMailer::Base

  def feedback(feedback)
    @recipients = EMAIL_RECIPIENT
    @from = EMAIL_FROM
    @sent_on = Time.now
    @subject = "PHA: Feedback [#{feedback.category}]"

    # Email body substitutions
    @type = feedback.category
    @feedback = feedback.feedback
    @name = feedback.name
    @email = feedback.email
    @phone = feedback.phone
    @availability = feedback.availability
    @state = feedback.state_abbrev
    mail(to: @recipients, subject: @subject, from: @from, date: @sent_on)
  end

  def aaa_application(partner)
    @recipients = EMAIL_RECIPIENT
    @from = EMAIL_FROM
    @sent_on = Time.now
    @subject = "PHA: PAL Application"

    @partner = partner
    mail(to: @recipients, subject: @subject, from: @from, date: @sent_on)
  end


  def unavailable_plan_feedback(counseling)
    @recipients = EMAIL_RECIPIENT
    @from = EMAIL_FROM
    @subject = "PHA: A user has requested to be contacted regarding a plan that is not in the PHA database"
    @state = counseling.work_state_abbrev,
    @county = County.find(counseling.county_id).name,
    @city =  (counseling.city_id ? City.find(counseling.city_id).name : nil),
    @plan_name = counseling.plan_name,
    @agency_name = counseling.agency_name,
    @job_function = counseling.job_function,
    @feedback_email = counseling.feedback_email
    mail(to: @recipients, subject: @subject, from: @from, date: @sent_on)
  end

  def counseling_results(email, counseling, results, lost_plan_resources)
    @recipients = email
    @from = EMAIL_FROM
    @subject = "Your PensionHelp America results"


    @counseling = counseling
    @results = results
    @lost_plan_resources = lost_plan_resources

    mail(to: @recipients, subject: @subject, from: @from, date: @sent_on)
  end

  def links(errors)
    @from = LINK_CHECKER_FROM
    @recipients = LINK_CHECKER_RECIPIENT
    @subject = "Link checker results"
    @errors = errors
    mail(to: @recipients, subject: @subject, from: @from, date: @sent_on,"return-path"=>LINK_CHECKER_FROM)
  end
end
