# AIRFIELD
# Post -- A single post of content

class Post < ActiveRecord::Base

  # Relationships:
  belongs_to :author, :class_name=>"User"

  # Scopes:
  scope :published, where(["published_at != ?", nil])

  # Attributes:
  attr_accessible :author_id, :content, :name, :page_id, :position, :properties, :type

end
