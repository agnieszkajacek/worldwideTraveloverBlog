class Post < ApplicationRecord
  include ImageUploader[:cover]
  attr_accessor :crop_x
  
  extend FriendlyId
  friendly_id :title, use: :slugged

  belongs_to :category, optional: true

  validates :title, :content, :category_id, presence: true

  def self.search(search)
    where("title ILIKE :q", q: "%#{search}%") 
  end
end
