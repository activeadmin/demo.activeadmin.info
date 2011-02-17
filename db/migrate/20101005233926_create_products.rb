class CreateProducts < ActiveRecord::Migration
  def self.up
    create_table :products do |t|
      t.string :title
      t.text :description
      t.string :author
      t.decimal :price, :precision => 8, :scale => 2
      t.boolean :featured
      t.date :available_on
      t.string :image_file_name
      t.timestamps
    end
    add_index :products, :featured
    add_index :products, :available_on
  end

  def self.down
    drop_table :products
  end
end
