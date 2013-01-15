# AIRFIELD
# Page -- Top-level static page

class Page < Content

  # The content column of a Page is a serialized key set:
  serialize :matter, ContentMashSerializer.new

end
