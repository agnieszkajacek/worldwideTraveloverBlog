# frozen_string_literal: true

class Post < ApplicationRecord
  include ImageUploader[:cover]

  include PgSearch::Model
  pg_search_scope :search_for, against: %i(title introduction)

  extend FriendlyId
  friendly_id :title, use: :slugged

  belongs_to :category, optional: false
  validates :title, :content, :introduction, :category_id, presence: true

  # def self.search(search)
  #   where('title ILIKE :q', q: "%#{search}%")
  # end
end
