class CreateRooms < ActiveRecord::Migration[8.1]
  def change
    create_table :rooms do |t|
      t.references :venue, null: false, foreign_key: true
      t.string :name, null: false
      t.integer :room_type
      t.integer :floor
      t.integer :capacity, null: false
      t.decimal :area_sq_ft, precision: 10, scale: 2, null: false
      t.boolean :accessible, null: false

      t.timestamps
    end
  end
end
