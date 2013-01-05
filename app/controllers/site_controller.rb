# AIRFIELD
# SiteContoller -- display site content

class SiteController < ApplicationController

  before_filter :preload_pages
  before_filter :preload_links

  # Site Homepage
  def index
    @posts = Post.order("created_at DESC").page(params[:page] || 1).per(5)    # published()
  end

  # View a static page
  def page
    @page = Page.where(:slug=>params[:id]).first() || Page.where(:id=>params[:id]).first()
    @page_title = @page.name

    respond_to do |fmt|
      fmt.html
      fmt.text if @page.markdown?
    end
  end

  # View a static post
  def post
    @post = Post.where(:slug=>params[:id]).first() || Post.where(:id=>params[:id]).first()
    @page_title = @post.name

    respond_to do |fmt|
      fmt.html
      fmt.text if @post.markdown?
    end
  end

  # View a category of posts
  def category
    @category_name = params[:id]
    @posts = Post.tagged_with(@category_name, :on=>:categories)
    @page_title = @category_name
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
