class Subscriber < ApplicationRecord
  validates :email, presence: true
  before_create :add_unsubscribe_hash

  private

  def add_unsubscribe_hash
    self.unsubscribe_hash = SecureRandom.hex
  end
end
