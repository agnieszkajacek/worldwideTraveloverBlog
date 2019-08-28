# frozen_string_literal: true

class SubscribersController < ApplicationController
  def create
    existing_subscriber = Subscriber.find_by(email: params[:subscriber][:email])

    if !is_user_a_human?
      redirect_to root_path, notice: 'Wygląda na to, że jesteś botem :('
    elsif  existing_subscriber&.subscription
      redirect_to root_path, notice: 'Wygląda na to, że już ze mną jesteś na bieżąco :)'
    elsif existing_subscriber && !existing_subscriber.subscription
      existing_subscriber.subscription = true
      existing_subscriber.save
      redirect_to root_path, notice: 'Witamy ponownie! :)'
    else
      @subscriber = Subscriber.create(subscriber_params)
      if @subscriber.save
        cookies[:saved_subscriber] = true
        NotificationMailer.welcome_email(@subscriber).deliver_now
        redirect_to root_path, notice: 'Hura! Udało Ci się zapisać do newslettera!'
      end
    end
  end

  def unsubscribe
    subscriber = Subscriber.find_by_unsubscribe_hash(params[:unsubscribe_hash])

    if subscriber.present?
      subscriber.update_attribute(:subscription, false)
      cookies.delete :saved_subscriber
      redirect_to root_path, notice: 'Szkoda, że uciekasz :( Wróć tu kiedyś ponownie :)'
    else
      redirect_to root_path, notice: 'Błędny link do wypisania się z newslettera. Wypisz się krzystając z linka w mailu bądź skontaktuj się z nami.'
    end
  end

  private

  def is_user_a_human?
    response = HTTP.post('https://www.google.com/recaptcha/api/siteverify', params: {
                           secret: ENV['RECAPTCHA_PRIVATE_KEY'],
                           response: subscriber_params[:recaptcha_token]
                         }).parse
    response['success'] && response['score'] >= 0.5
  end

  def subscriber_params
    params.require(:subscriber).permit(:email, :recaptcha_token)
  end
end
