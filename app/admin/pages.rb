# AIRFIELD
# Admin / Pages

ActiveAdmin.register Page do

  # Menu
  menu :priority=>2

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

  # Customize the Show view
  show do
    attributes_table do
      row :id
      row :name
      row :slug
      row :parent
      row :format
      row :created_at
      row :published_at
      row :updated_at
    end

    panel "View" do
      div(:style=>"padding:10px; margin: 1em 2em;") do
        render_markdown(page.matter)
      end
    end

  end

  # Customize the Form
  form :partial=>"form"

  # Customize the controller:
  controller do
    defaults :finder => :find_by_slug
  end

end
