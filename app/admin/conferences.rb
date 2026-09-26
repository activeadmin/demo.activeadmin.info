ActiveAdmin.register Conference do
  permit_params :name, :slug, :description, :status, :start_date, :end_date, :daily_start_time, :daily_end_time, :ticket_price, :website_url, :capacity, :published, :venue_id

  actions :all

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
    column :created_at, class: "min-w-48"
    column :updated_at, class: "min-w-48"
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
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.semantic_errors(*f.object.errors.attribute_names)
    f.inputs do
      f.input :name
      f.input :slug
      f.input :description
      f.input :status
      f.input :start_date
      f.input :end_date
      f.input :daily_start_time
      f.input :daily_end_time
      f.input :ticket_price
      f.input :website_url
      f.input :capacity
      f.input :published
      f.input :venue
    end
    f.actions
  end
end
