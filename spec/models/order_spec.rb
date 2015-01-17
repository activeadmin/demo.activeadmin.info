require 'rails_helper'

RSpec.describe Order, :type => :model do
  context "Associations" do
    it {should belong_to(:user)}
    it {should have_many(:line_items).dependent(:destroy)}
  end
end

