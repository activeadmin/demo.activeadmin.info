# frozen_string_literal: true

# In-memory API stand-in adapted from activeadmin/activeadmin#9039.
# Returns a page and metadata without a database or external service.
class ApiPost
  extend ActiveModel::Naming

  Record = Data.define(:id, :title, :status)
  Search = Data.define(:title_cont, :status_eq)
  Result = Data.define(:records, :total_count, :limit, :offset)

  ALL_RECORDS = [
    Record.new(id: 1, title: "Alpha", status: "active"),
    Record.new(id: 2, title: "Beta", status: "inactive"),
    Record.new(id: 3, title: "Gamma", status: "active"),
    Record.new(id: 4, title: "Delta", status: "active"),
    Record.new(id: 5, title: "Epsilon", status: "inactive"),
    Record.new(id: 6, title: "Zeta", status: "active"),
    Record.new(id: 7, title: "Eta", status: "active")
  ].freeze

  def self.fetch(page: 1, per_page: 5, title_cont: nil, status_eq: nil)
    page = [page.to_i, 1].max
    per_page = per_page.to_i

    records = ALL_RECORDS
    records = records.select { |record| record.title.include?(title_cont) } if title_cont.present?
    records = records.select { |record| record.status == status_eq } if status_eq.present?

    offset = (page - 1) * per_page
    page_records = if offset < records.size
      records[offset, per_page]
    else
      []
    end

    Result.new(
      records: page_records,
      total_count: records.size,
      limit: per_page,
      offset: offset
    )
  end
end
