# AIRFIELD
# Post -- A single post of content

class Post < ActiveRecord::Base # temp. save: Content

  # Post taxonomy:
  acts_as_taggable_on :categories
  attr_accessible :category_list

end
