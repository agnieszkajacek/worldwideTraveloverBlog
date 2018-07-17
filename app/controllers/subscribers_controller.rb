class SubscribersController < ApplicationController
  def new
    @subscriber = Subscriber.new
  end
  def create
    @subscriber = Subscriber.new(subscriber_params)
    if @subscriber.save!
      cookies[:saved_subscriber] = true
      redirect_to root_path, notice: 'Saved successfully!'
    else
      redirect_to root_path, notice: 'Failed to save'
    end
  end

  private
  def subscriber_params
    params.require(:subscriber).permit(:name, :email, :source)
  end
end
