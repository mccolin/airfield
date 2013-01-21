# AIRFIELD
# Admin / Pages

ActiveAdmin.register Page do

  # Menu
  menu :priority=>2

  # Index Sort:
  config.sort_order = "position_asc"

  # Scopes
  scope :all, :default=>true
  scope :published
  scope :unpublished

  # Customize the Index Listing
  index do
    selectable_column
    #column :id
    #column :position
    column :name
    #column :format
    column :author
    #column :created_at
    #column :published_at
    default_actions

    # Helpful Admin Text:
    panel "Pages Admin" do
      text_node %{
        This is a list of the major static pages of your site. Click to view, edit, or delete
        a page and drag this list to re-order pages as they appear in navigation.
      }.html_safe
    end
  end


  # Resort Pages (UI drag-and-drop):
  # This action is called by javascript when you drag and drop a column
  # It iterates through the collection and sets the new position based on the
  # order that jQuery submitted them
  collection_action :sort, :method => :post do
    params[:page].each_with_index do |id, index|
      Page.update_all(['position=?', index+1], ['id=?', id])
    end
    render :nothing => true
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
