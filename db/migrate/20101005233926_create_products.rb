class CreateProducts < ActiveRecord::Migration
  def self.up
    create_table :products do |t|
      t.string :title
      t.text :description
      t.decimal :price, :precision => 8, :scale => 2
      t.string :image_file_name
      t.timestamps
    end
  end

  def self.down
    drop_table :products
  end
end
