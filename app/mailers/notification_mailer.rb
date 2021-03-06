# frozen_string_literal: true

class NotificationMailer < ApplicationMailer
  default from: ENV['WT_DEFAULT_EMAIL'],
          reply_to: ENV['WT_EMAIL']

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
