# AIRFIELD
# AddSlugsToContent -- Support for sluggable URLs in content models

class AddSlugsToContent < ActiveRecord::Migration
  def change
    add_column :pages, :slug, :string, :after=>:name
    add_column :posts, :slug, :string, :after=>:name

    add_index :pages, :slug
    add_index :posts, :slug
  end
end
