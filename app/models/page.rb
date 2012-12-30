# AIRFIELD
# Page -- Top-level static page

class Page < ActiveRecord::Base

  # Relationships:
  belongs_to :author, :class_name=>"User"
  belongs_to :parent, :class_name=>"Page"
  has_many :children, :class_name=>"Page", :foreign_key=>"parent_id"

  # Scopes:
  scope :published, where(["published_at != ?", nil])
  scope :unpublished, where(:published_at=>nil)

  # Attributes:
  attr_accessible :author_id, :content, :format, :name, :parent_id, :position, :properties, :type, :published_at

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


  # Sluggable URLs:
  def to_param
    slug
  end

end
