ActiveAdmin.register Room do
  config.per_page = 10

  permit_params :venue_id, :name, :room_type, :floor, :capacity, :area_sq_ft, :accessible

  actions :all

  filter :id
  filter :venue
  filter :name
  filter :room_type
  filter :floor
  filter :capacity
  filter :area_sq_ft
  filter :accessible
  filter :created_at
  filter :updated_at

  index do
    selectable_column
    id_column
    column :venue, class: "min-w-48"
    column :name, class: "min-w-30"
    column :room_type
    column :floor
    column :capacity
    column :area_sq_ft, class: "min-w-24"
    column :accessible
    column :created_at, class: "min-w-48"
    column :updated_at, class: "min-w-48"
    actions
  end

  show do
    attributes_table_for(resource) do
      row :id
      row :venue
      row :name
      row :room_type
      row :floor
      row :capacity
      row :area_sq_ft
      row :accessible
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.semantic_errors(*f.object.errors.attribute_names)
    f.inputs do
      f.input :venue
      f.input :name
      f.input :room_type
      f.input :floor
      f.input :capacity
      f.input :area_sq_ft
      f.input :accessible
    end
    f.actions
  end
end
