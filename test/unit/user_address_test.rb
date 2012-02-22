require 'test_helper'

class UserAddressTest < ActiveSupport::TestCase
  def new_user(attrs = {})
    attrs[:username]              ||= 'martin.mcFly'
    attrs[:email]                 ||= 'martin@mcf.ly'
    attrs[:password]              ||= 'abc123'
    attrs[:password_confirmation] ||= attrs[:password]
    user = User.new(attrs)
    user.save!
    user
  end

  def new_user_address(attrs = {})
    attrs[:user_id]               ||= new_user.id
    attrs[:fullname]              ||= 'Martin McFly'
    attrs[:address_line1]         ||= '9303 Lion Drive'
    attrs[:city]                  ||= 'Hill Valley'
    attrs[:state]                 ||= 'California'
    attrs[:zipcode]               ||= '95420'
    attrs[:country]               ||= 'US'
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
end

