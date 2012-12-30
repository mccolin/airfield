# AIRFIELD
# SiteContoller -- display site content

class SiteController < ApplicationController

  before_filter :preload_pages


  # Site Homepage
  def index
    @posts = Post.order("created_at DESC").all() # published()
  end

  # View a static page
  def page
    @page = Page.find_by_slug(params[:id]) || Page.where(:id=>params[:id]).first()

    respond_to do |fmt|
      fmt.html
      if @page.markdown?
        fmt.text { render :text=>"#{@page.name}\n\n#{@page.content}" }
      end
    end
  end

  # View a static post
  def post
    @post = Post.find_by_slug(params[:id]) || Post.where(:id=>params[:id]).first()

    respond_to do |fmt|
      fmt.html
      if @post.markdown?
        fmt.text { render :text=>"#{@post.name}\n\n#{@post.content}" }
      end
    end
  end


  # Load pages for navigation and archive purposes for all site queries:
  def preload_pages
    @pages = Page.order(:position).order(:name).all() # published()
  end

end
