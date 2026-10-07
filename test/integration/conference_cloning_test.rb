require "test_helper"

class ConferenceCloningTest < ActionDispatch::IntegrationTest
  setup do
    @source = conferences(:one)
    sign_in default_admin_user
  end

  test "the clone form is read only until submitted" do
    assert_no_difference [-> { Conference.count }, -> { Session.count }] do
      get clone_as_draft_admin_conference_path(@source)
    end

    assert_response :success
    assert_select "form[action=?][method=post]", clone_as_draft_admin_conference_path(@source)
    assert_select "input[name='conference_cloner[include_speakers]'][type=checkbox][checked]"
  end

  test "cloning redirects to the editable draft and only accepts clone options" do
    post clone_as_draft_admin_conference_path(@source), params: {
      conference_cloner: {
        name: "Next conference", slug: "next-conference", start_date: "2027-09-24", end_date: "2027-09-24",
        include_speakers: "0", published: true, venue_id: venues(:two).id
      }
    }

    copy = Conference.find_by!(slug: "next-conference")
    assert_redirected_to edit_admin_conference_path(copy)
    assert_predicate copy, :draft?
    assert_not_predicate copy, :published?
    assert_equal @source.venue_id, copy.venue_id
    assert_empty copy.session_speakers
  end

  test "invalid submissions display localized errors and retain the entered values" do
    assert_no_difference -> { Conference.count } do
      post clone_as_draft_admin_conference_path(@source), params: {
        conference_cloner: { name: "Next conference", slug: @source.slug, start_date: "2027-09-24", end_date: "2027-09-23" }
      }
    end

    assert_response :unprocessable_entity
    assert_select "[role=alert]", text: /End date must be on or after the start date/
    assert_select "input[name='conference_cloner[name]'][value='Next conference']"
  end

  test "cloning requires an authenticated admin" do
    sign_out default_admin_user

    assert_no_difference -> { Conference.count } do
      post clone_as_draft_admin_conference_path(@source), params: { conference_cloner: { name: "Unauthorized copy" } }
    end
    assert_redirected_to new_admin_user_session_path
  end
end
