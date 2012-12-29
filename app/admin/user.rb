# AIRFIELD
# Admin / Users

ActiveAdmin.register User do

  # Scopes
  scope :all, :default=>true
  scope :admins

  # Customize the Index Listing
  index do
    selectable_column
    column :id
    column :name
    column :email
    column :created_at
    default_actions
  end

  # Query filters
  filter :admin
  filter :first_name
  filter :last_name
  filter :email

  # Customize the Edit Form
  form do |f|
    f.inputs do
      f.input :first_name
      f.input :last_name
      f.input :email
      if f.object.new_record?
        f.input :password
        f.input :password_confirmation
      end
      f.input :admin
    end
    f.actions
  end

end
