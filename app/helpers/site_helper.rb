# AIRFIELD
# SiteHelper -- Helpers for displaying the user site, pages, posts

module SiteHelper

  # Display a site title
  def site_title
    if current_page?(home_path)
      "I Am McColin - Colin McCloskey"
    elsif @page_title
      "#{@page_title} - I Am McColin"
    else
      "I Am McColin"
    end
  end

  # Render a navigable menu with links to pages
  def site_page_navigation_menu(pages, menu_html={}, item_html={})
    content_tag :ul, menu_html do
      pages.each do |page|
        site_page_navigation_item(page.name, page_path(page), item_html)
      end
    end
  end

  # Render an active/inactive navigation item for the given link path, title
  def site_page_navigation_item(text, path, link_html_opts={}, li_html_opts={})
    li_class = current_page?(path) ? "active" : ""
    content_tag :li, li_html_opts.merge(:class=>li_class) do
      link_to text.html_safe, path, link_html_opts
    end
  end

  # Render a link as an iconned button
  def btn_link_to(text, path, opts={})
    html_opts = opts
    html_classes = %w(btn)
    if klass = html_opts.delete(:class)
      html_classes << klass
    end
    html_opts[:class] = html_classes.join(" ")
    if icon = html_opts.delete(:icon)
      text = "<i class=\"icon-#{icon}\"></i> #{text}"
    end
    link_to text.html_safe, path, html_opts
  end


  # Render a container block for a collection of content with appropriate HTML wrappers:
  def content_collection(content_set, opts={}, &block)
    html_attribs = {"data-content-collection"=>content_set.first.class.to_s, "data-content-count"=>content_set.count}
    html_attribs.merge!(opts[:html]) if opts[:html]
    html_tag_name = opts[:tag] || :span
    content_tag html_tag_name, html_attribs do
      capture(&block)
    end
  end


  # Render a container block for an individual content item with appropriate HTML wrappers:
  def content_container(content_obj, opts={}, &block)
    html_attribs = {"data-content-type"=>content_obj.class.to_s, "data-content-item"=>content_obj.id}
    html_attribs["data-content-new"] = true if content_obj.new_record?
    html_attribs.merge!(opts[:html]) if opts[:html]
    html_tag_name = opts[:tag] || :span
    content_tag html_tag_name, html_attribs do
      capture(&block)
    end
  end

  # Render an editable container block for an attribute or attr/key for content. Given a block,
  # this method will render the contents of the block as its inner text. Without a block, the
  # simple text value of the attribute named will be inserted as inner text:
  def content_attribute(content_obj, attr_name, opts={}, &block)
    html_attribs = {"data-content-attr"=>attr_name}
    html_attribs["data-content-key"] = opts[:key] if opts[:key]
    html_attribs.merge!(opts[:html]) if opts[:html]

    html_tag_name = opts[:tag] || :span

    if block_given?
      content_tag html_tag_name, html_attribs do
        capture(&block)
      end
    else
      content_tag html_tag_name, content_obj.send(attr_name), html_attribs
    end
  end



  # Select and sanitize a random string from a set
  def random_and_sane(set)
    set[rand(set.length)].html_safe
  end

  # Greeting string
  def greeting
    now = DateTime.now
    if now.month == 10
      "Boo!"
    elsif now.month == 1 && now.day == 23
      "It's my Birthday!"
    elsif now.month == 12 && now.day > 12 && now.day <= 25
      "Ho! Ho! Ho!"
    else
      random_and_sane %w(Hi! Hi! Hi. Hey. Hello. Hola!)
    end
  end

  # Subtitle string
  def subtitle
    random_and_sane [
      "Bearded computery nerd person.",
      "Philadelphia- and carbon-based life form.",
      "Zombie, shark, and snake fascinator.",
      "Statistical, analytical, atypical man person.",
      "I often wear slippers to work"
    ]
  end

  # Powered by attribution string
  def powered_by
    random_and_sane [
      "Diet Pepsi",
      "the funny voice he uses to talk to dogs",
      "the love of his life, <a href=\"http://thebluesunshine.com/\">Lizza</a>",
      "hoagies from <a href=\"https://foursquare.com/v/sarcones-deli/4a9b035ef964a520fc3320e3\">Sarcone's Deli</a>",
      "his sweet tooth for #{random_and_sane ['Nerds rope','Mike and Ikes','Peppermint Patties']}",
      "any and all potatoes",
      "rays of sunshine trickling through his backyard fig tree"
    ]
  end


  # Render Radius-based templates:
  def render_axtags(template)
    AirfieldTagLibrary.parse(template)
  end

end
