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

end
