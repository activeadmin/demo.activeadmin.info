require 'test_helper'

class ProductsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Product.first
    assert_template 'show'
  end
end
