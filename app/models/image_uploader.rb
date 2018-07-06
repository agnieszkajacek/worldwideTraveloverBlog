require 'image_processing/mini_magick'

class ImageUploader < Shrine
  plugin :processing # allows hooking into promoting
  plugin :versions   # enable Shrine to handle a hash of files
  plugin :delete_raw # delete processed files after uploading
  plugin :determine_mime_type
  plugin :validation_helpers
  plugin :pretty_location

  Attacher.validate do
    validate_max_size 5.megabytes, message: 'is too large (max is 5 MB)'
    validate_mime_type_inclusion %w[image/jpg image/jpeg image/png image/gif]
  end

  process(:store) do |io, context|
    original = io.download

    thumbnail = ImageProcessing::MiniMagick
      .source(original)
      .resize_to_limit!(250, 250)

    original.close!

    { original: io, thumbnail: thumbnail }
  end

  def generate_location(io, context = {})
    type  = context[:record].class.name.downcase if context[:record]
    style = context[:version] == :original ? "originals" : "thumbs" if context[:version]
    category_name = context[:record].category.name if context[:record].category_id
    name = context[:metadata]["filename"]

    [type, style, category_name, name].compact.join("/")
  end
end
