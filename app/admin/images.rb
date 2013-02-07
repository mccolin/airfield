# AIRFIELD
# Admin / Images

ActiveAdmin.register Image do

  # Menu
  menu :priority=>6

  # # Customize the Index Listing
  # index do
  #   selectable_column
  #   column :site
  #   column :author
  #   column :name
  #   column :image
  #   column :created_at
  #   default_actions

  #   # Helpful Admin Text:
  #   panel "Images Admin" do
  #     text_node %{
  #       This is a set of images that have been uploaded to your site. They are
  #       able to be used in content like posts and pages.
  #     }.html_safe
  #   end
  # end

  # Display the image gallery as a grid:
  index :as => :block do |image|
    div :for=>image, :class=>"image_block" do
      span do
        link_to(image_tag(image.image.thumb("150x150#").url), admin_image_path(image))
      end
      span do
        simple_format image.name || "Image #{image.id}"
      end
    end
  end

  # Customize the View screen
  show do
    panel "Image" do
      span do
        link_to(image_tag(image.image.url, :title=>"Full Size", :style=>"max-width:100%;"), image.image.url, :target=>"_blank") + "<br/>".html_safe
      end
      span do
        image_tag(image.image.thumb("300x>").url, :title=>"300px Thumbnail")
      end
      span do
        image_tag(image.image.thumb("150x150#").url, :title=>"150px Square Thumbnail")
      end
      span do
        image_tag(image.image.thumb("150x150").url, :title=>"150px Thumbnail")
      end
    end
    attributes_table do
      row :name
      row :caption
      row :author
      row :site
      row :created_at
      row :updated_at
    end
  end

  # Customize the Index Filters
  filter :site
  filter :author
  filter :name
  filter :image_name
  filter :created_at

  # Customize the Form
  form :partial=>"form"

end
