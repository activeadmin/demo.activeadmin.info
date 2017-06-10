class CreateUserAddresses < ActiveRecord::Migration[5.1]
  def self.up
    create_table :user_addresses do |t|
      t.integer  :user_id
      t.string   :fullname
      t.string   :address_line1
      t.string   :address_line2
      t.string   :city
      t.string   :state
      t.string   :zipcode
      t.string   :country
      t.timestamps
    end
    add_index(:user_addresses, :user_id)
  end

  def self.down
    drop_table :user_addresses
  end
end
