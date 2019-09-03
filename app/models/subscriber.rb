# frozen_string_literal: true

class Subscriber < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.freeze

  validates :email, presence: true,
                    format: {
                      with: VALID_EMAIL_REGEX
                    }

  before_create :add_unsubscribe_hash

  attr_accessor :recaptcha_token

  private

  def add_unsubscribe_hash
    self.unsubscribe_hash = SecureRandom.hex
  end
end
