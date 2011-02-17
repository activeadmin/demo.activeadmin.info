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
