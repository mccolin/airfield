# AIRFIELD
# CreatePages -- backing for static Page content

class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      # Link a page to potential parent page:
      t.integer :parent_id

      # Link a page to its author:
      t.integer :author_id

      # Lock a page in a menu position:
      t.integer :position

      # Multi-type support for Page subclassing:
      t.string :type

      # Name/Title and Body Content:
      t.string :name
      t.text :content

      # Key-Value properties:
      t.text :properties

      # Creation/Update timing:
      t.timestamps

      # Publishing Control:
      t.datetime :published_at
    end

    # Lookup pivots:
    add_index :pages, :author_id
    add_index :pages, :parent_id
  end
end
