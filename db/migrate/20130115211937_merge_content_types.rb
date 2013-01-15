# AIRFIELD
# MergeContentTypes -- migration unifies the Page and Post backings to create a
#  single Content structure.

class Content < ActiveRecord::Base
  self.table_name = "content"
  attr_accessible :site_id, :parent_id, :author_id, :position, :type, :format, :name, :slug, :matter, :layout, :properties, :created_at, :updated_at, :published_at
end
class Page < ActiveRecord::Base; end
class Post < ActiveRecord::Base; end

class MergeContentTypes < ActiveRecord::Migration
  def up

    create_table "content" do |t|
      t.integer :site_id
      t.integer :parent_id
      t.integer :author_id
      t.integer :position
      t.string :type
      t.string :format, :limit=>12, :default=>"html"
      t.string :name
      t.string :slug

      t.text :matter
      t.text :layout
      t.text :properties

      t.timestamps
      t.datetime :published_at, :null=>false
    end

    add_index :content, :site_id
    add_index :content, :parent_id
    add_index :content, :author_id
    add_index :content, :type
    add_index :content, :slug


    # Import all Page data into Content
    Page.all.each do |p|
      attrs = p.attributes
      attrs["matter"] = attrs.delete("content")
      attrs["published_at"] ||= attrs["created_at"]
      attrs["type"] ||= "Page"
      c = Content.create(attrs)
    end
    puts "Pulled #{Page.count} page items from `pages` table."
    puts "#{Content.count} items now in `content` table."

    # Import all Post data into Content:
    Post.all.each do |p|
      attrs = p.attributes.reject{|k,v| k == "page_id"}
      attrs["matter"] = attrs.delete("content")
      attrs["published_at"] ||= attrs["created_at"]
      attrs["type"] ||= "Post"
      c = Content.create(attrs)
    end
    puts "Pulled #{Post.count} post items from `posts` table."
    puts "#{Content.count} items now in `content` table."

    # Destroy the old Page, Post structures:
    drop_table "pages"
    drop_table "posts"
    puts "Prior tables `pages` and `posts` destroyed."
  end

  def down
    # This migration cannot be reversed
    raise ActiveRecord::IrreversibleMigration.new
  end
end
