ActiveAdmin.register Session do
  config.per_page = [10, 20, 30]

  permit_params :conference_id, :room_id, :title, :description, :session_type, :audience_level, :starts_at, :ends_at, :status, session_speakers_attributes: %i[id speaker_id _destroy]

  actions :all

  filter :id
  filter :conference
  filter :room
  filter :title
  filter :description
  filter :session_type
  filter :audience_level
  filter :starts_at
  filter :ends_at
  filter :status
  filter :created_at
  filter :updated_at

  batch_action(
    :update_session_details,
    partial: "update_session_details_batch_action_form",
    link_html_options: {
      "data-modal-target": "update-session-details-modal",
      "data-modal-show": "update-session-details-modal"
    }
  ) do |ids, inputs|
    Session.where(id: ids).update_all(
      status: inputs["status"],
      session_type: inputs["session_type"],
      audience_level: inputs["audience_level"]
    )
    redirect_to collection_path, notice: I18n.t("admin.session.batch_actions.update_session_details_notice")
  end

  index do
    selectable_column
    id_column
    column :conference, class: "min-w-44"
    column :room, class: "min-w-32"
    column :title, class: "min-w-48"
    column :session_type
    column :audience_level
    column :status
    column :starts_at, class: "min-w-48" do |session|
      format_time(session.starts_at)
    end
    column :ends_at, class: "min-w-48" do |session|
      format_time(session.ends_at)
    end
    column :created_at, class: "min-w-48" do |session|
      format_time(session.created_at)
    end
    column :updated_at, class: "min-w-48" do |session|
      format_time(session.updated_at)
    end
    actions
  end

  show do
    attributes_table_for(resource) do
      row :id
      row :conference
      row :room
      row :title
      row :description
      row :session_type
      row :audience_level
      row :starts_at do
        format_time(resource.starts_at)
      end
      row :ends_at do
        format_time(resource.ends_at)
      end
      row :status
      row :created_at do
        format_time(resource.created_at)
      end
      row :updated_at do
        format_time(resource.updated_at)
      end
    end
  end

  form do |f|
    f.semantic_errors(*f.object.errors.attribute_names)
    f.inputs do
      f.input :conference
      f.input :room
      f.input :title
      f.input :description
      f.input :session_type
      f.input :audience_level
      f.input :starts_at, as: :datetime_picker, selected: f.object.starts_at || Time.current
      f.input :ends_at, as: :datetime_picker, selected: f.object.ends_at || Time.current
      f.input :status
    end
    f.actions
  end
end
