class SubscribersController < ApplicationController
  def new
    @subscriber = Subscriber.new
  end
  def create
    @subscriber = Subscriber.new(subscriber_params)
    if @subscriber.save!
      cookies[:saved_subscriber] = true
      NotificationMailer.with(subscriber: @subscriber).welcome_email.deliver_now
      redirect_to root_path, notice: 'Super! Teraz nic Cię nie ominie :)'
    else
      redirect_to root_path, notice: 'Ups, coś poszło nie tak :('
    end
  end

  private
  def subscriber_params
    params.require(:subscriber).permit(:email)
  end
end
