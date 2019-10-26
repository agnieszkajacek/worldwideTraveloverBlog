# frozen_string_literal: true

require 'image_processing/mini_magick'

class ImageUploader < Shrine
  plugin :processing # allows hooking into promoting
  plugin :versions   # enable Shrine to handle a hash of files
  plugin :delete_raw, storages: [:store] # delete processed files after uploading
  plugin :determine_mime_type
  plugin :validation_helpers
  plugin :pretty_location
  plugin :default_url_options, store: { host: ENV["CDN_HOST"] }
  plugin :store_dimensions
  
  Attacher.validate do
    validate_max_size 13.megabytes, message: 'is too large (max is 13 MB)'
    validate_mime_type_inclusion %w[image/jpg image/jpeg image/png image/gif]
  end

  process(:store) do |io, context|
    original = io.download

    thumbnail = ImageProcessing::MiniMagick
                .quality(70)
                .crop("#{context[:record].crop_width}x#{context[:record].crop_height}+#{context[:record].crop_x}+#{context[:record].crop_y}")
                .scale('250x250')
                .convert('jpg')
                .call(original)

    medium = ImageProcessing::MiniMagick
             .quality(75)
             .crop("#{context[:record].crop_width}x#{context[:record].crop_height}+#{context[:record].crop_x}+#{context[:record].crop_y}")
             .scale('500x500')
             .convert('jpg')
             .call(original)

    if context[:record].is_a?(Post)
      rectangle = ImageProcessing::MiniMagick
                  .quality(85)
                  .crop("#{context[:record].crop_rectangle_width}x#{context[:record].crop_rectangle_height}+#{context[:record].crop_rectangle_x}+#{context[:record].crop_rectangle_y}")
                  .scale('750x500')
                  .convert('jpg')
                  .call(original)
      rectangle_webp = ImageProcessing::MiniMagick
                  .quality(85)
                  .crop("#{context[:record].crop_rectangle_width}x#{context[:record].crop_rectangle_height}+#{context[:record].crop_rectangle_x}+#{context[:record].crop_rectangle_y}")
                  .scale('750x500')
                  .convert('webp')
                  .call(original)
    end

    original.close
    versions = { original: io, thumbnail: thumbnail, medium: medium }

    versions[:rectangle] = rectangle if rectangle
    versions[:rectangle_webp] = rectangle_webp if rectangle_webp
    versions
  end

  def generate_location(_io, context = {})
    type  = context[:record].class.name.downcase if context[:record]
    style = context[:version] == :original ? 'originals' : 'thumbs' if context[:version]

    if (context[:record].is_a?(Photo) || context[:record].is_a?(Post)) && context[:record].category_id
      category_name = context[:record].category.name
    end

    category_name = context[:record].name if context[:record].is_a?(Category)

    name = context[:metadata]['filename']

    [type, style, category_name, name].compact.join('/')
  end
end
