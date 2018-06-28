require 'uploads'

class Photo < ApplicationRecord
  belongs_to :category, optional: true
  has_one_attached :file

  def file_picture_header_variant
    variation =
      ActiveStorage::Variation.new(Uploads.resize_to_fit(width: 500, height: 200, blob: file.blob))
      ActiveStorage::Variant.new(file.blob, variation)
  end
end
