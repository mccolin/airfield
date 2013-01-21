# AIRFIELD
# Admin / Links

ActiveAdmin.register Link do

  # Menu
  menu :priority=>9

  # Index Sort:
  config.sort_order = "position_asc"

  # No need for show view:
  actions :all, :except => [:show]

  # Scopes
  scope :all, :default=>true
  scope :in_header
  scope :in_footer

  # Customize the Index Listing
  index do
    selectable_column
    #column :id
    column "Where" do |link|
      if link.in_header? && link.in_footer?
        status_tag("Both", :ok)
      elsif link.in_header?
        status_tag("Header", :warn)
      elsif link.in_footer?
        status_tag("Footer", :warn)
      else
        status_tag("None", :error)
      end
    end
    #column :position
    column :name
    column :url
    default_actions
    panel "Menu Links Admin" do
      text_node %{
        Use this screen to manage the external links appearing in your menus. Drag
        links into the desired order and specify if they should appear in the top menu,
        bottom menu, or both.
      }.html_safe
    end
  end


  # Resort Links (UI drag-and-drop):
  # This action is called by javascript when you drag and drop a column
  # It iterates through the collection and sets the new position based on the
  # order that jQuery submitted them
  collection_action :sort, :method => :post do
    params[:link].each_with_index do |id, index|
      Link.update_all(['position=?', index+1], ['id=?', id])
    end
    render :nothing => true
  end


  # Customize the Form
  form do |f|
    f.inputs "Details" do
      f.input :name
      f.input :url
    end
    f.buttons
    f.inputs "Customization" do
      f.input :in_header, :label=>"Show in Header?", :hint=>"Checking this box will display this link in the site header"
      f.input :in_footer, :label=>"Show in Footer?", :hint=>"Checking this box will display this link in the site footer"
      f.input :position, :as=>:number, :hint=>"Lower positioned links appear earlier in menus", :input_html=>{:style=>"max-width:50px;"}
    end
    f.buttons
  end


  # Add bulk actions for header/footer assignment:
  # batch_action :show_in_header, :priority => 1 do |selection|
  #   Link.where(:id=>selection).update_all(:in_header=>true)
  # end
  # batch_action :show_in_footer, :priority => 2 do |selection|
  #   Link.where(:id=>selection).update_all(:in_footer=>true)
  # end
  # batch_action :hide_from_header, :priority => 3 do |selection|
  #   Link.where(:id=>selection).update_all(:in_header=>false)
  # end
  # batch_action :hide_from_footer, :priority => 4 do |selection|
  #   Link.where(:id=>selection).update_all(:in_footer=>false)
  # end

end
