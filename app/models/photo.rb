class Photo < ApplicationRecord
  include ImageUploader[:image]
  attr_accessor :crop_x
  belongs_to :category, optional: true
end
