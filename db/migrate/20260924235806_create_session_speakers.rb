class CreateSessionSpeakers < ActiveRecord::Migration[8.1]
  def change
    create_table :session_speakers do |t|
      t.references :session, null: false, foreign_key: true
      t.references :speaker, null: false, foreign_key: true

      t.timestamps
    end
  end
end
