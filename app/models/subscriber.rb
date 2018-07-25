class Subscriber < ApplicationRecord
  validates :name, :email, :source, presence: true
end
