# frozen_string_literal: true

module ApplicationHelper
  def markdown(text)
    markdown = Redcarpet::Markdown.new(
      Redcarpet::Render::HTML,
      no_intra_emphasis: true,
      fenced_code_blocks: true,
      disable_indented_code_blocks: true,
      autolink: true,
      tables: true,
      underline: true,
      highlight: true
    )
    markdown.render(text).html_safe
  end

  def replace_photos(text)
    # .to_str is needed because ActiveSupport::SafeBuffer breaks assignment to $1 in gsub block
    # https://github.com/rails/rails/commit/e05d4cea69919ed0a2e5832bde120b5d0f12c0ec#diff-f639a79f308e72f54af369291a4d5907
    text.to_str.gsub(/\{\{(show_lightbox|download):([0-9]+)\}\}/) do |match|
      photo = Photo.find_by(id: $2)
      if photo
        data = $1 == 'show_lightbox' ? {gallery: "gallery-name", toggle: "lightbox", footer: photo.name} : {}
        tag.div(class: 'text-center image-style') do
          tag.div(class: 'image') do
            link_to photo.image_url(:original, response_content_disposition: 'attachment'), data: data, download: true do
              tag.img(class: 'inline-image', loading: "lazy", width: "500", height: "500", src: photo.image_url(:medium, public: true))
            end
          end
        end
      else
        ''
      end
    end.html_safe
  end

  def render_source(args = {})
    @html_encoder ||= HTMLEntities.new
    raw(@html_encoder.encode(render(args)))
  end

  def active_class(link_path)
    current_page?(link_path) ? 'nav-link active' : 'nav-link'
  end
end
