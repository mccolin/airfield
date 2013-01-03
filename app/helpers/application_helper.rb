# AIRFIELD
# Helpers

module ApplicationHelper

  # Render a chunk of Markdown content:
  def render_markdown(src)
    @renderer ||= Redcarpet::Render::HTML.new
    @marker ||= Redcarpet::Markdown.new(@renderer, :autolink=>true)
    @marker.render(src).html_safe
  end

  # Render a series of content keys into a layout template:
  def render_content_in_layout(src, locals)
    template = Liquid::Template.parse(src)
    render_markdown template.render(locals)
  end

end
