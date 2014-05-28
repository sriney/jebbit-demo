class CreateSites < ActiveRecord::Migration
  def change
    create_table :sites do |t|
      t.string :name
      t.string :author
      t.date :created_at
      t.text :img_url
      t.text :landing_url

      t.timestamps
    end
  end
end
