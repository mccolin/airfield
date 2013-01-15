# AIRFIELD
# Content -- Each object of this type represents a block/node of content; this
#  includes static pages, stream posts, and more. Class has inherit children.

class Content < ActiveRecord::Base

  # Refer to a strictly-named database table:
  self.table_name = "content"

  # Relationships:
  belongs_to :author, :class_name=>"User"
  belongs_to :parent, :class_name=>"Content"
  has_many :children, :class_name=>"Content", :foreign_key=>"parent_id"

  # Scopes:
  scope :published, where(["published_at != ?", nil])
  scope :unpublished, where(:published_at=>nil)

  # Attributes:
  attr_accessible :site_id, :parent_id, :author_id, :position, :type, :format, :name, :slug,
                  :matter, :layout, :properties, :created_at, :updated_at, :published_at

  # Key-Value Properties:
  does_keys :column=>"properties"
  #has_key :foo, :type=>:boolean
  #has_key :bar, :type=>:integer

  # URL-parsing by slug:
  acts_as_url :name, :url_attribute=>:slug, :sync_url=>true


  def published?
    !published_at.nil? && published_at < DateTime.now
  end

  def markdown?
    format == "markdown"
  end

  def html?
    format == "html"
  end

  def layout
    src = read_attribute(:layout)
    src.blank? ? "{{content.body}}" : src
  end


  # Sluggable URLs:
  def to_param
    slug
  end


  protected

  # Ensure a publish date is set
  def set_publish_timestamp
    self.published_at = DateTime.now if self.published_at.nil?
  end
  before_save :set_publish_timestamp


end
