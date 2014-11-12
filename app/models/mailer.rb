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

    @partner = partner
    mail(to: @recipients, subject: @subject, from: @from, date: @sent_on)
  end

  def lsp_application(partner)
    @recipients = EMAIL_RECIPIENT
    @from = EMAIL_FROM
    @sent_on = Time.now
    @subject = "PHA: Legal Service Provider Application"

    # Email body substitutions
    @body["partner"] = partner
  end

  def user_application_confirmation(partner)
    @recipients = partner.user.email
    @from = EMAIL_FROM
    @subject = "Thank for joining our nationwide pension assistance network"
  end

  def unavailable_plan(counseling)
    @recipients = EMAIL_RECIPIENT
    @from = EMAIL_FROM
    @subject = "PHA: A user has requested information on a plan that is not in the PHA database"
    body :state => counseling.work_state_abbrev, :county => (County.find(counseling.county_id).name rescue nil),
         :city => (counseling.city_id ? City.find(counseling.city_id).name : nil),
         :plan_name => counseling.plan_name, :agency_name => counseling.agency_name, :job_function => counseling.job_function
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
    body["errors"] = errors

    @from = LINK_CHECKER_FROM
    @recipients = LINK_CHECKER_RECIPIENT
    @subject = "Link checker results"
    @headers["return-path"] = LINK_CHECKER_FROM
  end
end
