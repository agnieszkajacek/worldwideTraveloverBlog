class SubscribersController < ApplicationController
  def new
    @subscriber = Subscriber.new
  end
  def create
    subscriber = Subscriber.where(email: params[:subscriber][:email])
    
    if subscriber.exists?
      redirect_to root_path, notice: 'Wygląda na to, że już ze mną jesteś na bieżąco :)'
    else
      @subscriber = Subscriber.create(subscriber_params)
      if @subscriber.save!
        cookies[:saved_subscriber] = true
        NotificationMailer.with(subscriber: @subscriber).welcome_email.deliver_now
        redirect_to root_path, notice: 'Hura! Udało Ci się zapisać do newslettera!'
      end
    end
  end

  def unsubscribe
    subscriber = Subscriber.find_by_unsubscribe_hash(params[:unsubscribe_hash])
    subscriber.update_attribute(:subscription, false)
    cookies.delete :saved_subscriber
    redirect_to root_path, notice: 'Szkoda, że uciekasz :( Wróć tu kiedyś ponownie :)'
  end

  private
  def subscriber_params
    params.require(:subscriber).permit(:email)
  end
end
