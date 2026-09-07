# frozen_string_literal: true

require "application_system_test_case"

class ApiPostsTest < ApplicationSystemTestCase
  setup do
    sign_in default_admin_user
  end

  test "browsing a read-only resource across pages" do
    visit admin_root_path
    click_on "API Posts"

    assert_current_path admin_api_posts_path
    assert_text "Alpha"
    assert_text "Epsilon"
    refute_text "Zeta"
    assert_text "Showing 1-5 of 7"
    assert_no_selector "#index_table_api_posts th a"
    assert_no_selector "input[type='checkbox']"
    assert_no_link "New Api Post"
    assert_no_link "CSV"

    click_on "2", exact: true

    assert_text "Zeta"
    assert_text "Eta"
    refute_text "Alpha"
    assert_text "Showing 6-7 of 7"
  end

  test "filtering by status from the second page and clearing filters" do
    visit admin_api_posts_path(page: 2)
    select "inactive", from: "Status"
    click_on "Filter", exact: true

    assert_text "Beta"
    assert_text "Epsilon"
    refute_text "Alpha"
    refute_text "Zeta"
    assert_text "Showing all 2"
    assert_select "Status", selected: "inactive"
    assert_no_link "2", exact: true

    click_on "Clear Filters"

    assert_text "Alpha"
    assert_text "Showing 1-5 of 7"
    assert_select "Status", selected: "Any"
    assert_link "2", exact: true
  end

  test "filtering by title and status" do
    visit admin_api_posts_path
    fill_in "Title contains", with: "Bet"
    select "inactive", from: "Status"
    click_on "Filter", exact: true

    assert_text "Beta"
    refute_text "Alpha"
    refute_text "Epsilon"
    assert_text "Showing 1 of 1"
    assert_field "Title contains", with: "Bet"
    assert_select "Status", selected: "inactive"
    assert_no_link "2", exact: true
  end

  test "filtering without matches and clearing the empty result" do
    visit admin_api_posts_path
    fill_in "Title contains", with: "Missing"
    click_on "Filter", exact: true

    assert_text "No Api Posts found"
    assert_field "Title contains", with: "Missing"
    assert_no_selector "#index_table_api_posts"

    click_on "Clear Filters"

    assert_field "Title contains", with: ""
    assert_text "Alpha"
    assert_text "Showing 1-5 of 7"
  end
end
