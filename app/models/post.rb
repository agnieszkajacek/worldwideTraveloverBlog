class Post < ApplicationRecord
  include ImageUploader[:cover]
  belongs_to :category, optional: true

  validates :title, :content, :category_id, presence: true

  def self.search(search)
    where("title ILIKE :q", q: "%#{search}%") 
  end
end
