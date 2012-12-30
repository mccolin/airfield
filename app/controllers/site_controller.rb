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
  end

  # View a static post
  def post
    @post = Post.find_by_slug(params[:id]) || Post.where(:id=>params[:id]).first()
  end


  # Load pages for navigation and archive purposes for all site queries:
  def preload_pages
    @pages = Page.order(:name).all() # published()
  end

end
