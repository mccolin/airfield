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
