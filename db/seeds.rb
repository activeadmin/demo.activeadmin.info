# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
#

# Delete all the things!
LineItem.delete_all
Order.delete_all
User.delete_all
Product.delete_all

# Load each product from the yaml file
products = YAML.safe_load_file(Rails.root.join("db/seeds/products.yml"), permitted_classes: [Date, Symbol])
Product.insert_all(products)

NB_PRODUCTS = Product.count

# Create 100 users
NB_USERS = 100

users = Array.new(NB_USERS) do |index|
  password_salt = Digest::SHA1.hexdigest([Time.current, rand].join)
  {
    username: Faker::Internet.user_name + index.to_s,
    email: Faker::Internet.email.gsub("@", "#{index}@"),
    password_salt: password_salt,
    password_hash: Digest::SHA1.hexdigest(["password", password_salt].join)
  }
end
password_salt = Digest::SHA1.hexdigest([Time.current, rand].join)
password_hash = Digest::SHA1.hexdigest(["password", password_salt].join)
users << { username: "admin", email: "admin@example.com", password_salt: password_salt, password_hash: password_hash }
User.insert_all(users)

# Create 300 Orders
NB_ORDERS = 300

user_ids = User.pluck(:id)

orders = Array.new(NB_ORDERS) do
  { user_id: user_ids.sample }
end
Order.insert_all(orders)

order_ids = Order.pluck(:id)
product_ids = Product.pluck(:id)
prices_by_product_id = Product.pluck(:id, :price).to_h

NB_LINE_ITEMS = Array.new(NB_ORDERS) { rand(9) + 1 }.sum

line_items = Array.new(NB_LINE_ITEMS) do
  product_id = product_ids.sample
  {
    order_id: order_ids.sample,
    product_id: product_id,
    price: prices_by_product_id[product_id]
  }
end
LineItem.insert_all(line_items)

most_order_ids = order_ids.select { rand(100) < 80 }

Order.where(id: most_order_ids).find_each do |order|
  order.transaction do
    order.recalculate_price!
    order.checkout!
  end
end

puts "Seeded database with sample data"
