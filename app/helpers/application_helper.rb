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
    return markdown.render(text).html_safe
  end

  def render_source args={}
    @html_encoder ||= HTMLEntities.new
    raw(@html_encoder.encode(render args))
  end

  def active_class(link_path)
    current_page?(link_path) ? "nav-link active" : "nav-link"
  end
end
