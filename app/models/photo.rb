require 'uploads'

class Photo < ApplicationRecord
  belongs_to :category, optional: true
  has_one_attached :file

end
