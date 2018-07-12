class Post < ApplicationRecord
  include ImageUploader[:cover]
  belongs_to :category, optional: true

  validates :title, :content, :category_id, presence: true
end
