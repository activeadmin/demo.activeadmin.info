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

  index do
    selectable_column
    id_column
    column :conference, class: "min-w-44"
    column :room, class: "min-w-32"
    column :title, class: "min-w-48"
    column :session_type
    column :audience_level
    column :status
    column :starts_at, class: "min-w-48"
    column :ends_at, class: "min-w-48"
    column :created_at, class: "min-w-48"
    column :updated_at, class: "min-w-48"
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
      row :starts_at
      row :ends_at
      row :status
      row :created_at
      row :updated_at
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
    f.inputs "Speakers" do
      f.has_many :session_speakers, allow_destroy: true, new_record: "Add speaker" do |session_speaker|
        session_speaker.input :speaker
      end
    end
    f.actions
  end
end
