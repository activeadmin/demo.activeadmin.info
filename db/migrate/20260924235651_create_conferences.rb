class CreateConferences < ActiveRecord::Migration[8.1]
  def change
    create_table :conferences do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.text :description, null: false
      t.integer :status, null: false
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.time :daily_start_time, null: false
      t.time :daily_end_time, null: false
      t.decimal :ticket_price, precision: 10, scale: 2, null: false
      t.string :website_url, null: false
      t.integer :capacity, null: false
      t.boolean :published, null: false
      t.references :venue, null: false, foreign_key: true

      t.timestamps
    end
    add_index :conferences, :slug, unique: true
  end
end
