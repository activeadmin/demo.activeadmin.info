class CreateVenues < ActiveRecord::Migration[8.1]
  def change
    create_table :venues do |t|
      t.string :name, null: false
      t.text :description, null: false
      t.string :website_url
      t.string :contact_email, null: false
      t.string :contact_phone, null: false
      t.decimal :latitude, precision: 10, scale: 6
      t.decimal :longitude, precision: 10, scale: 6
      t.integer :capacity
      t.boolean :indoor, null: false
      t.boolean :accessible, null: false
      t.string :time_zone, null: false

      t.timestamps
    end
  end
end
