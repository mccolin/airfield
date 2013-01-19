# AIRFIELD
# Post -- A single post of content

class Post < Content

  # Post taxonomy:
  acts_as_taggable_on :categories
  attr_accessible :category_list

end
