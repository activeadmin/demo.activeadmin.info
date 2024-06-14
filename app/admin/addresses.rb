ActiveAdmin.register Address do
  permit_params :category, :street_address, :secondary_address, :city, :state_code, :postal_code, :country_code, :latitude, :longitude, :active

  actions :all, except: []

  filter :category, as: :check_boxes, collection: -> { Address.categories }
  filter :street_address
  filter :secondary_address
  filter :city
  filter :state_code
  filter :postal_code
  filter :country_code
  filter :latitude
  filter :longitude
  filter :active
  filter :created_at
  filter :updated_at

  index do
    selectable_column
    id_column
    column :category
    column :street_address
    column :secondary_address
    column :city
    column :state_code
    column :postal_code
    column :country_code
    column :latitude
    column :longitude
    column :active
    column :created_at
    column :updated_at
    actions
  end

  show do
    attributes_table_for(resource) do
      row :id
      row :category
      row :street_address
      row :secondary_address
      row :city
      row :state_code
      row :postal_code
      row :country_code
      row :latitude
      row :longitude
      row :active
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.semantic_errors(*f.object.errors.attribute_names)
    f.inputs do
      f.input :category, include_blank: false
      f.input :street_address
      f.input :secondary_address
      f.input :city
      f.input :state_code
      f.input :postal_code
      f.input :country_code
      f.input :latitude
      f.input :longitude
      f.input :active
    end
    f.actions
  end
end
