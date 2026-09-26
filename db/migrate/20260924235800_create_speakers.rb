class CreateSpeakers < ActiveRecord::Migration[8.1]
  def change
    create_table :speakers do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.text :bio, null: false
      t.string :company
      t.string :job_title
      t.string :email, null: false
      t.string :phone, null: false
      t.string :website_url, null: false

      t.timestamps
    end
  end
end
