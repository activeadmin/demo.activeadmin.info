# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
#

# Load each product from the yaml file
YAML.load_file(File.expand_path("../seeds/products.yml", __FILE__)).each do |product|
  Product.create! product
end

NB_PRODUCTS = Product.count

# Create 100 users
NB_USERS = 100

NB_USERS.times do |n|
  User.create! do |u|
    u.username = Faker::Internet.user_name + n.to_s
    u.email = Faker::Internet.email.gsub('@', "#{n}@")
    u.password = u.password_confirmation = 'password'
  end
end

# Create 300 Orders
NB_ORDERS = 300

NB_ORDERS.times do
  user_id = rand(NB_USERS - 1) + 1
  user = User.find(user_id)
  order = user.orders.create!
  nb_items = rand(9) + 1

  nb_items.times do
    product_id = rand(NB_PRODUCTS - 1) + 1
    product = Product.find(product_id)
    LineItem.create! do |l|
      l.order = order
      l.product = product
      l.price = product.price
    end
  end

  order.recalculate_price! and order.checkout! if rand(100) < 90
end
