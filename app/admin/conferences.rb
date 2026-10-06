ActiveAdmin.register Conference do
  permit_params :name, :slug, :description, :status, :start_date, :end_date, :daily_start_time, :daily_end_time,
    :ticket_price, :website_url, :capacity, :published, :venue_id,
    sessions_attributes: [
      :id, :title, :description, :room_id, :session_type, :audience_level, :starts_at, :ends_at, :status, :_destroy,
      { session_speakers_attributes: %i[id speaker_id _destroy] }
    ]

  actions :all

  member_action :schedule, method: :get do
    @conference = resource
    authorize! :read, @conference
    @page_title = "Conference Schedule"
    @time_zone = Time.find_zone!(@conference.venue.time_zone)
    @rooms = @conference.venue.rooms.order(:name).to_a
    @sessions = @conference.sessions.includes(:room, session_speakers: :speaker).order(starts_at: :asc, id: :asc).to_a
    @conflicts = ScheduleConflicts.new(@sessions)
    render "admin/conferences/schedule"
  end

  action_item :schedule, only: :show do
    link_to "View Schedule", schedule_admin_conference_path(resource), class: "action-item-button"
  end

  filter :id
  filter :name
  filter :slug
  filter :description
  filter :status
  filter :start_date
  filter :end_date
  filter :daily_start_time
  filter :daily_end_time
  filter :ticket_price
  filter :website_url
  filter :capacity
  filter :published
  filter :venue
  filter :created_at
  filter :updated_at

  batch_action :toggle_published, confirm: proc { I18n.t("admin.conference.batch_actions.toggle_published_confirmation") } do |ids|
    Conference.where(id: ids).update_all("published = NOT published")
    redirect_to collection_path, notice: I18n.t("admin.conference.batch_actions.toggle_published_notice")
  end

  member_action :toggle_published, method: :patch do
    resource.update_columns(published: !resource.published?)
    redirect_to resource_path, notice: I18n.t("admin.conference.action_items.toggle_published_notice")
  end

  action_item :toggle_published, only: :show do
    label_key = resource.published? ? "unpublish" : "publish"
    link_to(
      I18n.t("admin.conference.action_items.#{label_key}"),
      toggle_published_admin_conference_path(resource),
      method: :patch,
      class: "action-item-button"
    )
  end

  index do
    selectable_column
    id_column
    column :name, class: "min-w-40"
    column :slug, class: "min-w-40"
    column :status
    column :start_date, class: "min-w-30"
    column :end_date, class: "min-w-30"
    column :ticket_price, class: "min-w-32"
    column :capacity
    column :published
    column :venue, class: "min-w-40"
    column :created_at, class: "min-w-48" do |conference|
      format_time(conference.created_at)
    end
    column :updated_at, class: "min-w-48" do |conference|
      format_time(conference.updated_at)
    end
    actions
  end

  show do
    attributes_table_for(resource) do
      row :id
      row :name
      row :slug
      row :description
      row :status
      row :start_date
      row :end_date
      row :daily_start_time
      row :daily_end_time
      row :ticket_price
      row :website_url do
        link_to resource.website_url, resource.website_url, target: "_blank" if resource.website_url.present?
      end
      row :capacity
      row :published
      row :venue
      row :created_at do
        format_time(resource.created_at)
      end
      row :updated_at do
        format_time(resource.updated_at)
      end
    end
    panel "Program" do
      table_for resource.sessions.includes(:room, session_speakers: :speaker).order(starts_at: :asc, id: :asc) do
        column :title do |session|
          link_to session.title, admin_session_path(session)
        end
        column :room
        column :speakers do |session|
          session.session_speakers.map { it.speaker.full_name }.join(", ")
        end
        column :starts_at do |session|
          format_time(session.starts_at, time_zone: resource.venue.time_zone)
        end
      end
    end
  end

  form do |f|
    f.semantic_errors(*f.object.errors.attribute_names)
    f.inputs do
      f.input :name
      f.input :slug
      f.input :description
      f.input :status
      f.input :start_date, as: :date_picker, selected: f.object.start_date || Date.current
      f.input :end_date, as: :date_picker, selected: f.object.end_date || Date.current
      f.input :daily_start_time
      f.input :daily_end_time
      f.input :ticket_price
      f.input :website_url
      f.input :capacity
      f.input :published
      f.input :venue
    end
    f.inputs "Program" do
      rooms = Room.includes(:venue).order(:name).map { ["#{it.venue.name} — #{it.name}", it.id] }
      speakers = Speaker.order(:last_name, :first_name).map { [it.full_name, it.id] }
      f.has_many :sessions, heading: false, allow_destroy: true,
        new_record: "Add session", class: "program-session" do |session|
        session.input :title
        session.input :description
        session.input :room, collection: rooms
        session.input :session_type
        session.input :audience_level
        session.input :starts_at, as: :datetime_picker
        session.input :ends_at, as: :datetime_picker
        session.input :status
        session.has_many :session_speakers, heading: "Speakers", allow_destroy: true,
          new_record: "Add speaker", class: "program-speakers" do |assignment|
          assignment.input :speaker, collection: speakers
        end
      end
    end
    f.actions
  end
end
