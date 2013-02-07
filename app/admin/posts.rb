# AIRFIELD
# Admin / Posts

ActiveAdmin.register Post do

  # Menu
  menu :priority=>4

  # Index Sort:
  config.sort_order = "published_at_desc"

  # Scopes
  scope :all, :default=>true
  scope :published
  scope :unpublished

  # Customize the Index Listing
  index do
    selectable_column
    #column :id
    column :name
    #column :format
    column :author
    #column :created_at
    column :published_at
    default_actions

    # Helpful Admin Text:
    panel "Posts Admin" do
      text_node %{
        This is a list of the stream posts in your site. Click to view, edit, or delete
        an existing post.
      }.html_safe
    end
  end

  # Customize the Index Filters
  filter :site
  filter :author
  filter :name
  filter :slug
  filter :matter, :label=>"Body"
  filter :published_at

  # Customize the Show view
  show do
    panel "Body" do
      div(:style=>"padding:10px; margin: 1em 2em;") do
        render_markdown render_axtags(post.matter)
      end
      div do
        span :class=>"action_item" do
          link_to "Edit Post", edit_admin_post_path(post), :class=>"button"
        end
      end
    end
    attributes_table do
      row :id
      row :name
      row :slug
      row :type
      row :author
      row :format
      row :created_at
      row :published_at
      row :updated_at
    end
  end

  # Customize the Form
  form :partial=>"form"

  # Customize the controller:
  controller do
    defaults :finder => :find_by_slug
  end

end
