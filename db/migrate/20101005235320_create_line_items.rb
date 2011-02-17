class CreateLineItems < ActiveRecord::Migration
  def self.up
    create_table :line_items do |t|
      t.integer :order_id
      t.integer :product_id
      t.decimal :price
      t.timestamps
    end
    add_index :line_items, :order_id
    add_index :line_items, :product_id
  end

  def self.down
    drop_table :line_items
  end
end
