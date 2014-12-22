require 'rails_helper'

RSpec.describe Product, :type => :model do
  context "Validations" do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:price) }
    it { should validate_presence_of(:image_file_name) }
  end
end
