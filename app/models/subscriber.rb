# frozen_string_literal: true

class Subscriber < ApplicationRecord
  validates :email, presence: true
  before_create :add_unsubscribe_hash

  attr_accessor :recaptcha_token

  private

  def add_unsubscribe_hash
    self.unsubscribe_hash = SecureRandom.hex
  end
end
