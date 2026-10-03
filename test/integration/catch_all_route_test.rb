# frozen_string_literal: true

require "test_helper"

class CatchAllRouteTest < ActionDispatch::IntegrationTest
  test "unmatched routes render the not found page" do
    get "/missing-controller-test-route"

    assert_response :not_found
    assert_includes response.body, "The page you were looking for doesn’t exist."
  end

  test "unmatched post requests also render the not found page" do
    post "/missing-controller-test-route"

    assert_response :not_found
    assert_includes response.body, "The page you were looking for doesn’t exist."
  end
end
