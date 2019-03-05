class NewPostNotifierJob < ApplicationJob
  queue_as :default

  def perform(subscriber, post)
    NotificationMailer.post_email(subscriber, post).deliver
  end
end
