# AIRFIELD
# SiteContoller -- display site content

class SiteController < ApplicationController

  # Site Homepage
  def index
    @pages = Page.published()
    @posts = Post.all() # published()
  end

end
