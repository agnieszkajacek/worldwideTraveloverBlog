class NotificationMailer < ApplicationMailer
  default from: 'worldwide.travelover@worldwide-travelover.com',
          reply_to: "worldwide.travelover@gmail.com"

  def welcome_email(subscriber)
    @subscriber = subscriber
    mail(to: @subscriber.email, subject: 'Worldwide Travelover wita!')
  end

  def post_email(subscriber, post)
    @post = post
    @subscriber = subscriber
    mail(to: @subscriber.email, subject: 'Nowy post')
  end
end
