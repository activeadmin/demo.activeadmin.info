ActiveAdmin.register Venue do
  permit_params :name, :description, :website_url, :contact_email, :contact_phone, :latitude, :longitude, :capacity, :indoor, :accessible, :time_zone

  actions :all

  filter :id
  filter :name
  filter :description
  filter :website_url
  filter :contact_email
  filter :contact_phone
  filter :latitude
  filter :longitude
  filter :capacity
  filter :indoor
  filter :accessible
  filter :time_zone
  filter :created_at
  filter :updated_at

  index do
    selectable_column
    id_column
    column :name, class: "min-w-38"
    column :website_url, class: "min-w-34 break-all" do |venue|
      link_to venue.website_url, venue.website_url, target: "_blank" if venue.website_url.present?
    end
    column :location, class: "min-w-28" do |venue|
      link_to "View Location", "https://www.google.com/maps?q=#{venue.coordinates.join(',')}", target: "_blank" if venue.coordinates.present?
    end
    column :capacity
    column :indoor
    column :accessible
    column :time_zone
    column :created_at, class: "min-w-48"
    column :updated_at, class: "min-w-48"
    actions
  end

  show do
    attributes_table_for(resource) do
      row :id
      row :name
      row :description
      row :website_url do
        link_to resource.website_url, resource.website_url, target: "_blank" if resource.website_url.present?
      end
      row :contact_email do
        mail_to resource.contact_email if resource.contact_email.present?
      end
      row :contact_phone do
        link_to resource.contact_phone, "tel:#{resource.contact_phone}" if resource.contact_phone.present?
      end
      row :latitude
      row :longitude
      row :location do
        link_to "View Location on Google Maps", "https://www.google.com/maps?q=#{resource.coordinates.join(',')}", target: "_blank" if resource.coordinates.present?
      end
      row :capacity
      row :indoor
      row :accessible
      row :time_zone
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.semantic_errors(*f.object.errors.attribute_names)
    f.inputs do
      f.input :name
      f.input :description
      f.input :website_url
      f.input :contact_email
      f.input :contact_phone
      f.input :latitude
      f.input :longitude
      f.input :capacity
      f.input :indoor
      f.input :accessible
      f.input :time_zone,
        as: :select,
        collection: ActiveSupport::TimeZone.all.map { [it.to_s, it.tzinfo.name] }
    end
    f.actions
  end
end
