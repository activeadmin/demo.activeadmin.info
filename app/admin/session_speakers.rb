ActiveAdmin.register SessionSpeaker do
  permit_params :session_id, :speaker_id

  actions :all

  filter :id
  filter :session
  filter :speaker
  filter :created_at
  filter :updated_at

  index do
    selectable_column
    id_column
    column :session, class: "min-w-48"
    column :speaker, class: "min-w-48 break-all"
    column :created_at, class: "min-w-48" do |session_speaker|
      format_time(session_speaker.created_at)
    end
    column :updated_at, class: "min-w-48" do |session_speaker|
      format_time(session_speaker.updated_at)
    end
    actions
  end

  show do
    attributes_table_for(resource) do
      row :id
      row :session
      row :speaker
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
      f.input :session
      f.input :speaker
    end
    f.actions
  end
end
