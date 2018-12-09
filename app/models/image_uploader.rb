require 'image_processing/mini_magick'

class ImageUploader < Shrine
  plugin :processing # allows hooking into promoting
  plugin :versions   # enable Shrine to handle a hash of files
  plugin :delete_raw # delete processed files after uploading
  plugin :determine_mime_type
  plugin :validation_helpers
  plugin :pretty_location

  Attacher.validate do
    validate_max_size 5.megabytes, message: 'is too large (max is 13 MB)'
    validate_mime_type_inclusion %w[image/jpg image/jpeg image/png image/gif]
  end

  process(:store) do |io, context|
    original = io.download

   thumbnail = ImageProcessing::MiniMagick
      .quality(100)
      .crop("#{context[:record].crop_width}x#{context[:record].crop_height}+#{context[:record].crop_x}+#{context[:record].crop_y}")
      .scale('250x250')
      .call(original)

    medium = ImageProcessing::MiniMagick
      .quality(100)
      .crop("#{context[:record].crop_width}x#{context[:record].crop_height}+#{context[:record].crop_x}+#{context[:record].crop_y}")
      .scale('500x500')
      .call(original)

    original.close
    { original: io, thumbnail: thumbnail, medium: medium }
  end

  def generate_location(io, context = {})
    type  = context[:record].class.name.downcase if context[:record]
    style = context[:version] == :original ? "originals" : "thumbs" if context[:version]
    
    if (context[:record].is_a?(Photo) || context[:record].is_a?(Post) ) && context[:record].category_id
      category_name = context[:record].category.name
    end
    
    if context[:record].is_a?(Category)
      category_name = context[:record].name
    end
    
    name = context[:metadata]["filename"]
    
    [type, style, category_name, name].compact.join("/")
  end
end
