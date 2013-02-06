# AIRFIELD
# Media -- A single piece of UGC (or other) content. STI.

class Media < ActiveRecord::Base

  # Relationships:
  belongs_to :site
  belongs_to :author, :class_name=>"User"

  # Attributes:
  attr_accessible :author_id, :caption, :image_name, :image_uid, :name, :site_id, :type

end
