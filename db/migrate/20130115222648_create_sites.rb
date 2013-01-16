# AIRFIELD
# CreateSites -- Represent a site

class CreateSites < ActiveRecord::Migration
  def change
    create_table :sites do |t|
      t.string :name
      t.string :domain
      t.string :subdomain
      t.text :properties
      t.timestamps
    end
    add_index :sites, :domain
    add_index :sites, :subdomain

    # Create a default Site and assign it all content:
    s = Site.create(:name=>"Airfield Site")
    Content.update_all(:site_id=>s.id)
  end
end
