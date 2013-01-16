# AIRFIELD
# SiteContoller -- display site content

class SiteController < ApplicationController

  before_filter :preload_site
  before_filter :preload_pages
  before_filter :preload_links

  # 404 Response for missing pages and posts:
  rescue_from ActiveRecord::RecordNotFound do |e|
    logger.error "404 Not Found: #{e.message}"
    respond_to do |fmt|
      fmt.html { render :file=>"public/404.html", :layout=>nil, :status=>404 }
      fmt.text { render :text=>"Page not found.", :status=>404 }
    end
  end


  # Site Homepage
  def index
    @posts = if @site.home_blog
      @site.posts.order("created_at DESC").page(params[:page] || 1).per(5)    # published()
    else
      Post.where(:id=>nil)
    end
  end

  # View a static page
  def page
    if @page = @site.pages.where(:slug=>params[:id]).first() || Page.where(:id=>params[:id]).first()
      @page_title = @page.name

      respond_to do |fmt|
        fmt.html
        fmt.text if @page.markdown?
      end
    else
      raise ActiveRecord::RecordNotFound.new
    end
  end

  # View a static post
  def post
    if @post = @site.posts.where(:slug=>params[:id]).first() || Post.where(:id=>params[:id]).first()
      @page_title = @post.name

      respond_to do |fmt|
        fmt.html
        fmt.text if @post.markdown?
      end
    else
      raise ActiveRecord::RecordNotFound.new
    end
  end

  # View a category of posts
  def category
    @category_name = params[:id]
    @posts = @site.posts.tagged_with(@category_name, :on=>:categories)
    @page_title = @category_name
  end


  protected

  # Load site representation before all actions:
  def preload_site
    @site = Site.instance
    logger.debug "Airfield Site Instance: #{@site.id}:#{@site.name}"
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
