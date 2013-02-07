# AIRFIELD
# AirfieldTagLibrary -- Radius tag library for template rendering

# Create a testable tag library:
class AirfieldTagLibrary < AxTags::TagLibrary

  # Scope a region of content and render inner text within:
  #  TODO: parsing locals need to pass current page
  tag "content" do |tag|
    attrs = {
      "type"=>"Post",
      "scope"=>"published",
      "order"=>"published_at DESC",
      "page"=>1,
      "per"=>5
    }.merge(tag.attr)
    attrs["scope"] = "published" unless Content.respond_to?(attrs["scope"])

    contents = if tag.globals.content
      [tag.globals.content].flatten
    else
      Content.of_type(attrs["type"]).order(attrs["order"]).send(attrs["scope"]).page(attrs["page"]).per(attrs["per"])
    end

    inner_text = %{<span data-content-collection="#{attrs["type"]}" data-content-count="#{contents.count}">\n}
    contents.each do |c|
      tag.locals.content = c
      inner_text << %{<span data-content-item="#{c.id}" data-content-type="#{c.class.to_s}">\n} << tag.expand << %{\n</span> <!--/item-->\n}
    end
    inner_text << %{\n</span> <!--/collection-->\n\n}
  end


  # Render content name:
  tag "content:name" do |tag|
    %{<span data-content-attr="name">#{tag.locals.content.name}</span>}
  end

  # Render content title (alias for name tag):
  tag "content:title" do |tag|
    %{<span data-content-attr="name">#{tag.locals.content.name}</span>}
  end

  # Render content body matter:
  tag "content:body" do |tag|
    %{<span data-content-attr="matter" data-content-key="body">#{tag.locals.content.matter}</span>}
  end

  # Render content dateline:
  tag "content:date" do |tag|
    attrs = {
      "format"=>"%b %d %Y"
    }.merge(tag.attr)
    %{<span data-content-attr="published_at">#{tag.locals.content.published_at.strftime(attrs["format"])}</span>}
  end

  # Render content permalink:
  tag "content:permalink" do |tag|
    inner_text = tag.expand
    text = inner_text.blank? ? tag.locals.content.name : inner_text
    href = "/#{tag.locals.content.is_a?(Post) ? "post/" : ""}#{tag.locals.content.slug}"
    attrs = tag.attr.merge("data-content-link"=>"#{tag.locals.content.class.to_s}-#{tag.locals.content.id}").collect{|a,v| "#{a}=\"#{v}\""}.join(" ")

    %{<a href="#{href}" #{attrs}>#{text}</a>}
  end

  # Render the name of the content author
  tag "content:author" do |tag|
    %{<span data-content-attr="author">#{tag.locals.content.author.name}</span>}
  end


  # Render an image tag for embeddable media
  tag "image" do |tag|
    attrs = {
      "i"=>nil,                     # i: ID of the image to display
      "class"=>"axtags_image",      # class: HTML class to apply to the rendered image
      "size"=>nil,                  # size: NxM dimensions (passable to Dragonfly) of desired image
      "style"=>nil,                 # style: HTML style attribute
      "alt"=>nil                    # alt: HTML alt attribute
    }.merge(tag.attr)

    if image = Image.where(:id=>attrs["i"]).first
      url = attrs["size"] ? image.image.thumb(attrs["size"]).url : image.image.url
      alt = attrs["alt"] || image.name || "Image"
      %{<img src="#{url}" data-gallery-image="#{image.id}" alt="#{alt}" title="#{alt}" class="#{attrs["class"]}" style="#{attrs["style"]}" />}
    else
      %{<span class="error parse-error ui-state-error">Image not found in Site Media Gallery.</span>}
    end

  end


  # Render Markdown content within a given tag
  tag "markdown" do |tag|
    renderer ||= Redcarpet::Render::HTML.new
    marker ||= Redcarpet::Markdown.new(@renderer, :autolink=>true)
    marker.render( tag.expand )
  end


  tag "powered-by" do |t|
    set = [
      "Diet Pepsi",
      "the funny voice he uses to talk to dogs",
      "the love of his life, <a href=\"http://thebluesunshine.com/\">Lizza</a>",
      "hoagies from <a href=\"https://foursquare.com/v/sarcones-deli/4a9b035ef964a520fc3320e3\">Sarcone's Deli</a>",
      "his sweet tooth for Mike and Ikes",
      "any and all potatoes",
      "rays of sunshine trickling through his backyard fig tree"
    ]
    %{<span class="powered-by">#{set[rand(set.length)]}</span>}
  end

  tag "anchor" do |t|
    %{<a class="awesome_anchor" href="http://awesometown.com/">I am Awesome!</a>}
  end

end
