ActiveAdmin.register Speaker do
  config.per_page = 15

  permit_params :first_name, :last_name, :bio, :company, :job_title, :email, :phone, :website_url

  actions :all

  filter :id
  filter :first_name
  filter :last_name
  filter :bio
  filter :company
  filter :job_title
  filter :email
  filter :phone
  filter :website_url
  filter :created_at
  filter :updated_at

  index do
    selectable_column
    id_column
    column :first_name, class: "min-w-30"
    column :last_name, class: "min-w-28"
    column :company, class: "min-w-34"
    column :job_title, class: "min-w-34"
    column :phone, class: "min-w-32"
    column :created_at, class: "min-w-48"
    column :updated_at, class: "min-w-48"
    actions
  end

  show do
    attributes_table_for(resource) do
      row :id
      row :first_name
      row :last_name
      row :bio
      row :company
      row :job_title
      row :email do
        mail_to resource.email if resource.email.present?
      end
      row :phone do
        link_to resource.phone, "tel:#{resource.phone}" if resource.phone.present?
      end
      row :website_url do
        link_to resource.website_url, resource.website_url, target: "_blank" if resource.website_url.present?
      end
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.semantic_errors(*f.object.errors.attribute_names)
    f.inputs do
      f.input :first_name
      f.input :last_name
      f.input :bio
      f.input :company
      f.input :job_title
      f.input :email
      f.input :phone
      f.input :website_url
    end
    f.actions
  end
end
