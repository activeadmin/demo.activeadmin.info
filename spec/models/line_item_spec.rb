require 'rails_helper'

RSpec.describe LineItem, :type => :model do
  context "Associations" do
    it {should belong_to(:order)}
    it {should belong_to(:product)}
  end
end
