require "test_helper"

class UserAddressTest < ActiveSupport::TestCase
  def new_user(attrs = {})
    attrs[:username]              ||= "martin.mcFly"
    attrs[:email]                 ||= "martin@mcf.ly"
    attrs[:password]              ||= "abc123"
    attrs[:password_confirmation] ||= attrs[:password]
    user = User.new(attrs)
    user.save!
    user
  end

  def new_user_address(attrs = {})
    attrs[:fullname]              ||= "Martin McFly"
    attrs[:address_line1]         ||= "9303 Lion Drive"
    attrs[:city]                  ||= "Hill Valley"
    attrs[:state]                 ||= "California"
    attrs[:zipcode]               ||= "95420"
    attrs[:country]               ||= "US"
    attrs[:user_id] = attrs.key?(:user_id) ? attrs[:user_id] : new_user.id
    user_address = UserAddress.new(attrs)
    user_address.valid?
    user_address
  end

  def setup
    UserAddress.delete_all
    User.delete_all
  end

  def test_valid
    assert new_user_address.valid?
  end

  def test_require_user
    address = new_user_address(user_id: nil)
    assert address.user.nil?, "user should be nil"
    assert !address.errors[:user_id].empty?, "should contain user_id error"
  end

  def test_require_fullname
    address = new_user_address(fullname: "")
    assert !address.errors[:fullname].empty?
  end

  def test_require_address_line1
    address = new_user_address(address_line1: "")
    assert !address.errors[:address_line1].empty?
  end

  def test_require_city
    address = new_user_address(city: "")
    assert !address.errors[:city].empty?
  end

  def test_require_state
    address = new_user_address(state: "")
    assert !address.errors[:state].empty?
  end

  def test_require_zipcode
    address = new_user_address(zipcode: "")
    assert !address.errors[:zipcode].empty?
  end

  def test_require_country
    address = new_user_address(country: "")
    assert !address.errors[:country].empty?
  end
end
