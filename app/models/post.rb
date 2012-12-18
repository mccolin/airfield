# AIRFIELD
# Post -- A single post of content

class Post < ActiveRecord::Base

  # Relationships:
  belongs_to :author, :class_name=>"User"

  # Scopes:
  scope :published, where(["published_at != ?", nil])
  scope :unpublished, where(:published_at=>nil)

  # Attributes:
  attr_accessible :author_id, :content, :name, :page_id, :position, :properties, :type, :published_at

  # Key-Value Properties:
  does_keys :column=>"properties"
  #has_key :foo, :type=>:boolean
  #has_key :bar, :type=>:integer


  def published?
    !published_at.nil? && published_at < DateTime.now
  end


  protected

  # Ensure a publish date is set
  def set_publish_timestamp
    update_attribute(:published_at, created_at) if published_at.nil?
  end
  after_save :set_publish_timestamp

end
