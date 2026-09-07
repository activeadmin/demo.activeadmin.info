# frozen_string_literal: true

require "test_helper"

class ApiPostTest < ActiveSupport::TestCase
  test "fetch returns a page of records and the total count" do
    first_page = ApiPost.fetch
    second_page = ApiPost.fetch(page: 2)

    assert_equal %w[Alpha Beta Gamma Delta Epsilon], first_page.records.map(&:title)
    assert_equal 7, first_page.total_count
    assert_equal 5, first_page.limit
    assert_equal 0, first_page.offset
    assert_equal %w[Zeta Eta], second_page.records.map(&:title)
    assert_equal 7, second_page.total_count
    assert_equal 5, second_page.offset
  end

  test "filters are combined before pagination" do
    result = ApiPost.fetch(title_cont: "ta", status_eq: "active", per_page: 2, page: 2)

    assert_equal ["Eta"], result.records.map(&:title)
    assert_equal 3, result.total_count
    assert_equal 2, result.limit
    assert_equal 2, result.offset
    assert_equal 7, ApiPost.fetch.total_count
  end

  test "blank filters are ignored" do
    result = ApiPost.fetch(title_cont: "", status_eq: "")

    assert_equal 7, result.total_count
    assert_equal 5, result.records.size
  end

  test "empty results and out of range pages return no records" do
    no_matches = ApiPost.fetch(title_cont: "Missing")

    assert_empty no_matches.records
    assert_equal 0, no_matches.total_count

    [3, 10**20].each do |page|
      out_of_range = ApiPost.fetch(page: page)

      assert_empty out_of_range.records
      assert_equal 7, out_of_range.total_count
    end
  end

  test "invalid page numbers use the first page" do
    [0, -1, "invalid"].each do |page|
      assert_equal ApiPost.fetch, ApiPost.fetch(page: page)
    end
  end
end
