# AIRFIELD
# AddFormatToContent -- Adds a "format" column to help content including
#  pages and posts support multiple types (html, md, txt, etc.)

class AddFormatToContent < ActiveRecord::Migration
  def change
    add_column :pages, :format, :string, :limit=>12, :default=>"html", :after=>:type
    add_column :posts, :format, :string, :limit=>12, :default=>"html", :after=>:type
  end
end
