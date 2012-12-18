# AIRFIELD
# CreatePosts -- Backing for individual Post data

class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      # Posts can belong to a parent page
      t.integer :page_id

      # Link to the author:
      t.integer :author_id

      # Allow posts to be pinned in a given order:
      t.integer :position

      # Subclassable post types:
      t.string :type

      # Name/title and body content:
      t.string :name
      t.text :content

      # Key-Value data:
      t.text :properties

      # The usual suspects:
      t.timestamps

      # Publishing Control:
      t.datetime :published_at
    end

    # Lookup pivots:
    add_index :posts, :author_id
    add_index :posts, :page_id
  end
end
