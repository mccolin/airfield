# AIRFIELD
# CreateLinks -- Logical backing for external/custom Menu links

class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      # Links can be in hierarchy and ordered:
      t.integer :parent_id
      t.integer :position

      # Links can be displayed in header and/or footer regions:
      t.boolean :in_header, :null=>false, :default=>true
      t.boolean :in_footer, :null=>false, :default=>true

      # Link name and href:
      t.string :name
      t.string :url

      t.timestamps
    end
  end
end
