class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :user_id
      t.datetime :checked_out_at
      t.decimal :total_price ,:precision => 8, :scale => 2, :default => 0.0

      t.timestamps
    end
    add_index :orders, :user_id
    add_index :orders, :checked_out_at
  end
end
