# AIRFIELD
# Site -- Represent a single site and its properties

class Site < ActiveRecord::Base

  # Relationships:
  has_many :content, :class_name=>"Content"
  has_many :pages, :class_name=>"Page"
  has_many :posts, :class_name=>"Post"
  has_many :images

  #has_many :children, :class_name=>"Content", :foreign_key=>"parent_id"

  # Attributes:
  attr_accessible :domain, :name, :properties, :subdomain

  # Strictly-defined property keys:
  does_keys :column=>"properties"
  has_key :home_blog, :type=>:boolean, :default=>true, :index=>false
  has_key :home_page_id, :type=>:integer, :default=>nil, :index=>false


  # Airfield configures only a single Site:
  def self.instance
    Site.first
  end

end
