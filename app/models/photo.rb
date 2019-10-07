# frozen_string_literal: true

class Photo < ApplicationRecord
  include ImageUploader[:image]

  belongs_to :category, optional: false
  validates :name, :category_id, presence: true
end
