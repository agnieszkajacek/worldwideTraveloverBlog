class SubscribersController < ApplicationController
  def new
    @subscriber = Subscriber.new
  end
  def create
    @subscriber = Subscriber.new(subscriber_params)
    if @subscriber.save!
      cookies[:saved_subscriber] = true
      NotificationMailer.with(subscriber: @subscriber).welcome_email.deliver_now
      redirect_to root_path
    end
  end

  def unsubscribe
    subscriber = Subscriber.find_by_unsubscribe_hash(params[:unsubscribe_hash])
    subscriber.update_attribute(:subscription, false)
    cookies.delete :saved_subscriber
    redirect_to root_path, notice: 'Nie będziesz otrzymywać już powiadomień'
  end

  private
  def subscriber_params
    params.require(:subscriber).permit(:email, :subscription)
  end
end
