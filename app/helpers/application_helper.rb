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
  def render_content_in_layout_OLD(src, locals)
    template = Liquid::Template.parse(src)
    locals["content"].each do |key, value|
      locals["content"][key] = render_markdown(value)
    end
    render_markdown template.render(locals)
  end

  # Render regions of content from a supporting object within a given layout:
  def render_content_in_layout(layout, object)
    content = object.content
    layout.gsub /\{\{(.+?)\}\}/ do |tag_invocation|
      logger.ap tag_invocation

      if md = tag_invocation.match(/^\{\{\s*?(\w+)(.*?)\}\}$/)
        tag = md[1]
        token_string = md[2]
        tokens = Hash[ token_string.strip.split(/\s+/).collect {|token| token.split("=").collect{|key_val| key_val.gsub(/\W/,"") } } ]

        if tag == "content"

          if key = tokens["key"]
            content_tag :span, :class=>"editable", "data-content-type"=>object.class.to_s.underscore, "data-content-id"=>object.id, "data-content-key"=>key do
              render_markdown object.content.send(key)
            end
          else
            content_tag :span, "Layout tag \"#{tag}\" requires providing a \"key\" attribute for proper parsing.", :class=>"error parse-error ui-state-error"
          end

        else # if content
          content_tag :span, "Unsupported layout tag \"#{tag}\" caused parsing error", :class=>"error parse-error ui-state-error"
        end # if content
      else
        content_tag :span, "Tag #{tag} with token string #{token_string} caused parsing error.", :class=>"error parse-error ui-state-error"
      end

    end.html_safe
  end

end
