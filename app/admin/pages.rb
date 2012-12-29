# AIRFIELD
# Admin / Pages

ActiveAdmin.register Page do

  # Scopes
  scope :all, :default=>true
  scope :published
  scope :unpublished

  # Customize the Index Listing
  index do
    selectable_column
    column :id
    column :name
    column :format
    column :author
    column :created_at
    column :published_at
    default_actions
  end

  # Customize the Form
  form :partial=>"form"

end
