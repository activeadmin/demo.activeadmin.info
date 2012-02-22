require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  def new_product(attrs = {})
    attrs[:title]           ||= 'FooBar Product'
    attrs[:price]           ||= 123.45
    attrs[:image_file_name] ||= 'foobar.jpeg'
    product = Product.new(attrs)
    product
  end

  def setup
    Product.delete_all
  end

  def test_should_be_valid
    assert new_product.valid?
  end
end

