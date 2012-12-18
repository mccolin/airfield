# AIRFIELD
# Page -- Top-level static page

class Page < ActiveRecord::Base

  # Relationships:
  belongs_to :author, :class_name=>"User"

  # Scopes:
  scope :published, where(["published_at != ?", nil])

  # Attributes:
  attr_accessible :author_id, :content, :name, :parent_id, :position, :properties, :type

end
