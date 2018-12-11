class NotificationMailer < ApplicationMailer
  default from: 'worldwide.travelover@worldwide-travelover.com',
          reply_to: "worldwide.travelover@gmail.com"

  def welcome_email
    @subscriber = params[:subscriber]
    mail(to: @subscriber.email, subject: 'Worldwide Travelover wita!')
  end

  def post_email(subscriber, post)
    @post = post
    mail(to: subscriber, subject: 'Nowy post')
  end
end
