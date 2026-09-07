# frozen_string_literal: true

ActiveAdmin.register ApiPost do
  menu label: "API Posts"
  actions :index

  config.batch_actions = false
  config.comments = false
  config.per_page = 5
  # Active-filter chips require a Ransack search, unlike the filter form.
  config.current_filters = false

  filter :title_cont, as: :string, label: "Title contains"
  filter :status_eq, as: :select, label: "Status", collection: %w[active inactive]

  index title: "API Posts", download_links: false do
    column :id, sortable: false
    column :title, sortable: false
    column :status, sortable: false
  end

  controller do
    protected

    # Bypass the ActiveRecord pipeline and adapt an already-paginated API response.
    def find_collection(*)
      query = params[:q] || {}
      @search = ApiPost::Search.new(title_cont: query[:title_cont], status_eq: query[:status_eq])

      result = ApiPost.fetch(
        page: params.fetch(:page, 1),
        per_page: active_admin_config.per_page,
        title_cont: search.title_cont,
        status_eq: search.status_eq
      )

      Kaminari.paginate_array(
        result.records,
        total_count: result.total_count,
        limit: result.limit,
        offset: result.offset
      )
    end

    private

    attr_reader :search
  end
end
