# AIRFIELD
# AddTemplateToContent -- adds rendering template storage alongside content

class AddTemplateToContent < ActiveRecord::Migration
  def change
    add_column :pages, :layout, :text, :after=>:content
    add_column :posts, :layout, :text, :after=>:content
  end
end
