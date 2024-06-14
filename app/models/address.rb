class Address < ApplicationRecord
  enum category: [:home, :work, :other]

  validates :category, :street_address, :city, :state_code, :postal_code, :country_code, presence: true

  # category:string street_address:string secondary_address:string city:string state_code:string postal_code:string country_code:string latitude:decimal longitude:decimal active:boolean
end
