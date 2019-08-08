class Category < ApplicationRecord
  include ImageUploader[:cover]

  extend FriendlyId
  friendly_id :name, use: :slugged

  validates :name, presence: true

  has_many :posts
  has_many :photos

  has_ancestry
end
