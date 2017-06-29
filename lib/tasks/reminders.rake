namespace :reminder do

  desc "send remind if not enter hours today"
  task :send => :environment do
    # only continue if today is work day
    if Time.now.to_date.cwday < 6
      # only send to people that have no records today
      users = User.needs_notifications
      if users.present?
        message = Message.new
        message.bcc = users.map(&:email)
        message.subject = I18n.t("mailer.notification.reminder.subject")
        message.message = I18n.t("mailer.notification.reminder.message")
        NotificationMailer.reminder(message).deliver
     end
    end

  end

end
