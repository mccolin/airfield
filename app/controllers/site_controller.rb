# AIRFIELD
# SiteContoller -- display site content

class SiteController < ApplicationController

  # Site Homepage
  def index
    @pages = Page.order(:name).all() # published()
    @posts = Post.order("created_at DESC").all() # published()
  end

  # View a static page
  def page
    @page = Page.where(:id=>params[:id]).first()
  end

  # View a static post
  def post
    @post = Post.where(:id=>params[:id]).first()
  end

end
