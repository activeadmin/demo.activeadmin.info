require "test_helper"

class ConferencePublishingTest < ActionDispatch::IntegrationTest
  setup do
    @conference = conferences(:one)
    @session = sessions(:one)
    sign_in default_admin_user
  end

  test "the readiness report links directly to sessions needing attention" do
    @session.session_speakers.destroy_all
    @session.update!(room: rooms(:two))

    assert_no_difference [-> { Conference.count }, -> { Session.count }, -> { SessionSpeaker.count }] do
      get readiness_admin_conference_path(@conference)
    end

    assert_response :success
    assert_select "h2", text: I18n.t("admin.conference.readiness.blocked")
    assert_select "a[href=?]", edit_admin_session_path(@session), count: 2
    assert_select "a[href=?]", toggle_published_admin_conference_path(@conference), count: 0
  end

  test "a ready program can be published from the report" do
    get readiness_admin_conference_path(@conference)

    assert_response :success
    assert_select "h2", text: I18n.t("admin.conference.readiness.ready")
    assert_select "a[href=?][data-method=patch]", toggle_published_admin_conference_path(@conference)

    patch toggle_published_admin_conference_path(@conference)

    assert_redirected_to admin_conference_path(@conference)
    assert_predicate @conference.reload, :published?
  end

  test "an empty program links to a new session with the conference selected" do
    @conference.sessions.destroy_all

    get readiness_admin_conference_path(@conference)

    assert_select "a[href=?]", new_admin_session_path(session: { conference_id: @conference.id }), text: I18n.t("admin.conference.readiness.add_session")

    get new_admin_session_path, params: { session: { conference_id: @conference.id } }

    assert_response :success
    assert_select "select[name='session[conference_id]'] option[selected][value=?]", @conference.id.to_s
  end

  test "the publish action rejects an incomplete program" do
    @session.session_speakers.destroy_all

    patch toggle_published_admin_conference_path(@conference)

    assert_redirected_to readiness_admin_conference_path(@conference)
    assert_equal I18n.t("admin.conference.readiness.publish_blocked"), flash[:alert]
    assert_not_predicate @conference.reload, :published?
  end

  test "the edit form cannot bypass readiness checks" do
    @session.session_speakers.destroy_all

    patch admin_conference_path(@conference), params: { conference: { published: "1" } }

    assert_response :unprocessable_entity
    assert_includes response.body, I18n.t("admin.conference.readiness.issues.missing_speakers", title: @session.title)
    assert_not_predicate @conference.reload, :published?
  end

  test "the edit form can publish a ready conference" do
    patch admin_conference_path(@conference), params: { conference: { published: "1" } }

    assert_redirected_to admin_conference_path(@conference)
    assert_predicate @conference.reload, :published?
  end

  test "a failed batch rolls back earlier changes and redirects to the failing report" do
    conferences = Conference.order(:id).to_a
    first, last = conferences
    first.update_columns(published: true)
    last.update_columns(published: false)
    last.sessions.first.session_speakers.destroy_all

    post batch_action_admin_conferences_path, params: { batch_action: "toggle_published", collection_selection: conferences.map(&:id) }

    assert_redirected_to readiness_admin_conference_path(last)
    assert_equal I18n.t("admin.conference.batch_actions.toggle_published_blocked"), flash[:alert]
    assert_predicate first.reload, :published?
    assert_not_predicate last.reload, :published?
  end

  test "incomplete conferences can still be unpublished" do
    @conference.update_columns(published: true)
    @session.session_speakers.destroy_all

    patch toggle_published_admin_conference_path(@conference)

    assert_redirected_to admin_conference_path(@conference)
    assert_not_predicate @conference.reload, :published?
  end

  test "missing speaker assignments can be fixed in the session edit form" do
    @session.session_speakers.destroy_all

    patch admin_session_path(@session), params: { session: { session_speakers_attributes: { "0" => { speaker_id: speakers(:one).id } } } }

    assert_redirected_to admin_session_path(@session)
    assert_predicate ConferenceReadiness.new(@conference), :ready?
  end

  test "readiness requires an authenticated admin" do
    sign_out default_admin_user

    get readiness_admin_conference_path(@conference)

    assert_redirected_to new_admin_user_session_path
  end
end
