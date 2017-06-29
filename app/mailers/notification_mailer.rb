class NotificationMailer < ActionMailer::Base
  default :from => ENV['APPLICATION_FEEDBACK_FROM_EMAIL']
  layout 'mailer'

  def new_user(message)
    @message = message
    mail(:to => ENV['APPLICATION_FEEDBACK_TO_EMAIL'], :subject => message.subject)
  end

  def reminder(message)
    @message = message
    mail(:bcc => message.bcc, :subject => message.subject)
  end

end
