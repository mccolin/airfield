# AIRFIELD
# ContentTag -- A Liquid templating tag for rendering content

class ContentTag < Liquid::Tag

  # Initialize the tag and declare arguments
  def initialize(tag_name, markup, tokens)
    @tag_name = tag_name
    @markup = markup
    @tokens = tokens

    super

    @key = @markup.strip.split(/\s+/).first
  end

  # Render the tag
  def render(context)
    @object = context["object"]
    @content = @object["content"]
    @available_content = @content.keys
    @src = @content.send(@content_key)

    if @object && @src
      content_type = @object.class.to_s.underscore
      content_id = @object.id
      "<span class=\"editable\" data-content-type=\"#{content_type}\" data-content-id=\"#{content_id}\" data-content-key=\"#{@key}\">#{@src}</span>"
    elsif @object
      "<span class=\"error parse-error ui-state-error\">Layout template references non-present key #{@key}. Available keys are #{@available_content.join(", ")}.</span>"
    elsif @src
      "<span class=\"error parse-error ui-state-error\">No referencable object provided to layout engine</span>"
    else
      "<span class=\"error parse-error ui-state-error\">General layout error.</span>"
    end
  end

  # def initialize(tag_name, snippet_name, tokens)
  #   super
  #   @name = snippet_name
  # end

  # def render(context)
  #   # You might want to define caching mechanism here
  #   snippet = Snippet.find_by_name(@name)
  #   unless snippet.nil?
  #     Liquid::Template.parse(snippet.body).render
  #   else
  #     "Error: Snippet #{@name} was not found!"
  #   end
  # end

end

