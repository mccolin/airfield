# AIRFIELD
# CreateMedia -- Represent a single Media object (image, video, etc.)

class CreateMedia < ActiveRecord::Migration
  def change
    create_table :media do |t|
      t.integer :site_id
      t.integer :author_id
      t.string :type
      t.string :name
      t.string :caption
      t.string :image_uid
      t.string :image_name

      t.timestamps
    end

    add_index :media, :site_id
    add_index :media, :type

  end
end
