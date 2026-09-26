class CreateSessions < ActiveRecord::Migration[8.1]
  def change
    create_table :sessions do |t|
      t.references :conference, null: false, foreign_key: true
      t.references :room, null: false, foreign_key: true
      t.string :title, null: false
      t.text :description, null: false
      t.integer :session_type
      t.integer :audience_level
      t.datetime :starts_at, null: false
      t.datetime :ends_at, null: false
      t.integer :status, null: false

      t.timestamps
    end
  end
end
