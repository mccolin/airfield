# AIRFIELD
# Link -- A single menu link to an external or custom reference

class Link < ActiveRecord::Base

  # Scopes:
  scope :in_header, where(:in_header=>true)
  scope :in_footer, where(:in_footer=>true)

  # Attributes:
  attr_accessible :in_footer, :in_header, :name, :parent_id, :position, :url

end
