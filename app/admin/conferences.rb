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

  member_action :clone_as_draft, method: [:get, :post] do
    attributes = request.post? ? params.require(:conference_cloner).permit(:name, :slug, :start_date, :end_date, :include_speakers).to_h.symbolize_keys : {}
    @cloner = ConferenceCloner.new(resource, attributes)
    @page_title = I18n.t("admin.conference.clone.title", name: resource.name)

    if request.post?
      if @cloner.save
        redirect_to edit_admin_conference_path(@cloner.conference), notice: I18n.t("admin.conference.clone.notice")
      else
        render :clone_as_draft, status: :unprocessable_entity
      end
    end
  end

  action_item :clone, only: :show do
    link_to I18n.t("admin.conference.action_items.clone"), clone_as_draft_admin_conference_path(resource), class: "action-item-button"
  end

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
    f.actions
  end
end
