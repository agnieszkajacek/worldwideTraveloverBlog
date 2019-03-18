class SubscribersController < ApplicationController
  def new
    @subscriber = Subscriber.new
  end
  def create

    active_subscriber = Subscriber.where("email = ? AND subscription = ?", params[:subscriber][:email], true)
    unactive_subscriber = Subscriber.where("email = ? AND subscription = ?", params[:subscriber][:email], false)

    if !is_user_a_human?
      redirect_to root_path, notice: 'Wygląda na to, że jesteś botem :('
    elsif active_subscriber.exists?
      redirect_to root_path, notice: 'Wygląda na to, że już ze mną jesteś na bieżąco :)'
    elsif unactive_subscriber.exists?
      subscriber = unactive_subscriber.first
      subscriber.subscription = true
      subscriber.save!
      redirect_to root_path, notice: 'Witamy ponownie! :)'
    else
      @subscriber = Subscriber.create(subscriber_params)
      if @subscriber.save!
        #cookies[:saved_subscriber] = true
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

  def is_user_a_human?
    response = HTTP.post("https://www.google.com/recaptcha/api/siteverify", params: {
      secret: ENV["RECAPTCHA_PRIVATE_KEY"],
      response: subscriber_params[:recaptcha_token]
    }).parse

    response["success"] && response["score"] >= 0.5
  end

  def subscriber_params
    params.require(:subscriber).permit(:email, :recaptcha_token)
  end
end
