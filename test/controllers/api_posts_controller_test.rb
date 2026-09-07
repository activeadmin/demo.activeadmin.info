# frozen_string_literal: true

require "test_helper"

class ApiPostsControllerTest < ActionDispatch::IntegrationTest
  test "authentication is required" do
    get admin_api_posts_path

    assert_redirected_to new_admin_user_session_path
  end

  test "only HTML is supported" do
    sign_in default_admin_user

    %i[csv json xml].each do |format|
      get admin_api_posts_path(format: format)

      assert_response :unauthorized
    end
  end

  test "only the index action is routed" do
    routes = Rails.application.routes.routes.select do |route|
      route.defaults[:controller] == "admin/api_posts"
    end

    assert_equal ["index"], routes.map { |route| route.defaults[:action] }
    assert_equal ["GET"], routes.map(&:verb)
  end
end
