class Photo < ApplicationRecord
  include ImageUploader[:image]
  belongs_to :category, optional: true

  validates :name, :category_id, presence: true
end
