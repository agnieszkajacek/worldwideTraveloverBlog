# Preview all emails at http://localhost:3000/rails/mailers/notification_mailer
class NotificationMailerPreview < ActionMailer::Preview
  def welcome_email
    NotificationMailer.with(subscriber: Subscriber.last).welcome_email
  end
end
