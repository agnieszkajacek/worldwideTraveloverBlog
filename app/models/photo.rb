class Photo < ApplicationRecord
  include ImageUploader[:image]
  
  belongs_to :category, optional: true
end
