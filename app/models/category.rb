# frozen_string_literal: true

class Category < ApplicationRecord
  include ImageUploader[:cover]

  include PgSearch::Model
  pg_search_scope :search_for, against: %i(title introduction)
  
  extend FriendlyId
  friendly_id :name, use: :slugged

  validates :name, presence: true

  has_many :posts
  has_many :photos
  has_ancestry
end
