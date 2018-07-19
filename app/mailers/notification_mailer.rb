class NotificationMailer < ApplicationMailer
  default from: 'worldwide.travelover@worldwide-travelover.com',
          reply_to: "worldwide.travelover@gmail.com"

  def welcome_email
    @subscriber = params[:subscriber]
    @url  = 'http://example.com/login'
    mail(to: @subscriber.email, subject: 'Welcome to My Awesome Site')
  end
end
