# AIRFIELD
# Helpers

module ApplicationHelper

  # Render a chunk of Markdown content:
  def render_markdown(src)
    @renderer ||= Redcarpet::Render::HTML.new
    @marker ||= Redcarpet::Markdown.new(@renderer)
    @marker.render(src).html_safe
  end

end
