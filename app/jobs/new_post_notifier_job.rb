class NewPostNotifierJob < ApplicationJob
  queue_as :default

  def perform(subscriber, post)
  end
end
