# AIRFIELD
# SiteContoller -- display site content

class SiteController < ApplicationController

  before_filter :preload_pages
  before_filter :preload_links

  # Site Homepage
  def index
    @posts = Post.order("created_at DESC").all() # published()
  end

  # View a static page
  def page
    @page = Page.find_by_slug(params[:id]) || Page.where(:id=>params[:id]).first()

    respond_to do |fmt|
      fmt.html
      fmt.text if @page.markdown?
    end
  end

  # View a static post
  def post
    @post = Post.find_by_slug(params[:id]) || Post.where(:id=>params[:id]).first()

    respond_to do |fmt|
      fmt.html
      fmt.text if @post.markdown?
    end
  end

  # View a category of posts
  def category
    @category_name = params[:id]
    @posts = Post.tagged_with(@category_name, :on=>:categories)
  end


  # Load pages for navigation and archive purposes for all site queries:
  def preload_pages
    @pages = Page.order(:position).order(:name).all() # published()
  end

  # Load links for navigation and archive purposes for all site queries:
  def preload_links
    @links = Link.order(:position, :name)
  end

end
