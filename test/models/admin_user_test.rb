# frozen_string_literal: true

require "test_helper"

class AdminUserTest < ActiveSupport::TestCase
  test "ransackable_attributes" do
    assert AdminUser.ransackable_attributes
  end

  test "ransackable_associations" do
    assert_empty AdminUser.ransackable_associations
  end
end
