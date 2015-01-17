class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :title
      t.text :description
      t.string :author
      t.decimal :price
      t.boolean :featured
      t.date :available_on
      t.string :image_file_name

      t.timestamps
    end
    add_index :products, :featured
    add_index :products, :available_on
  end
end
