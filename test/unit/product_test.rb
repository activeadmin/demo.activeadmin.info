require "test_helper"

class ProductTest < ActiveSupport::TestCase
  def new_product(attrs = {})
    attrs[:title]           ||= "FooBar Product"
    attrs[:price]           ||= 123.45
    attrs[:image_file_name] ||= "foobar.jpeg"
    product = Product.new(attrs)
    product
  end

  def setup
    Product.delete_all
  end

  def test_should_be_valid
    assert new_product.valid?
  end

  def test_require_title
    assert new_product(title: "").errors[:title]
  end

  def test_require_price
    assert new_product(price: "").errors[:price]
  end

  def test_require_image
    assert new_product(image_file_name: "").errors[:image_file_name]
  end
end
