# AIRFIELD
# SiteHelper -- Helpers for displaying the user site, pages, posts

module SiteHelper

  # Render a navigable menu with links to pages
  def site_page_navigation_menu(pages, menu_html={}, item_html={})
    content_tag :ul, menu_html do
      pages.each do |page|
        site_page_navigation_item(page.name, page_path(page), item_html)
      end
    end
  end

  # Render an active/inactive navigation item for the given link path, title
  def site_page_navigation_item(text, path, html_opts={})
    li_class = current_page?(path) ? "active" : ""
    content_tag :li, :class=>li_class do
      link_to text, path, html_opts
    end
  end

  # Select and sanitize a random string from a set
  def random_and_sane(set)
    set[rand(set.length)].html_safe
  end

  # Subtitle string
  def subtitle
    random_and_sane [
      "Bearded computery nerd person.",
      "Hero. Husband. Ham-lover.",
      "Trained nerd and things enthusiast"
    ]
  end

  # Powered by attribution string
  def powered_by
    random_and_sane [
      "Diet Pepsi",
      "the funny voice he uses to talk to dogs",
      "the love of his life, <a href=\"http://thebluesunshine.com/\">Lizza</a>",
      "Cliff Lee's throwing motion",
      "his sweet tooth for Nerds rope",
      "any and all types of potatoes",
      "WaWa Hot to Go bowls, however gross they seem"
    ]
  end

end
