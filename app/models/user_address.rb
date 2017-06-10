class UserAddress < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :user_id
  validates_associated  :user

  validates_presence_of :fullname
  validates_presence_of :address_line1
  validates_presence_of :city
  validates_presence_of :state
  validates_presence_of :zipcode
  validates_presence_of :country
end
