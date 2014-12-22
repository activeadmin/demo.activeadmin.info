require 'rails_helper'

RSpec.describe User, :type => :model do

  context "Validations" do
    it { should validate_presence_of(:username) }
    it { should validate_uniqueness_of(:username) }
    it { should validate_uniqueness_of(:email) }
    it { should validate_presence_of :password}
    it { should validate_confirmation_of :password}
  end

  context "Associations" do
    it {should have_many(:orders)}
  end

end

