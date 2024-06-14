class CreateAddresses < ActiveRecord::Migration[7.1]
  def change
    create_table :addresses do |t|
      t.integer :category
      t.string :street_address
      t.string :secondary_address
      t.string :city
      t.string :state_code
      t.string :postal_code
      t.string :country_code
      t.decimal :latitude
      t.decimal :longitude
      t.boolean :active

      t.timestamps
    end
  end
end
