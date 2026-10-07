class ConferenceCloner
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :name, :string
  attribute :slug, :string
  attribute :start_date, :date
  attribute :end_date, :date
  attribute :include_speakers, :boolean, default: true

  attr_reader :source, :conference

  validates :name, :slug, :start_date, :end_date, presence: true
  validate :end_date_on_or_after_start_date
  validate :unique_slug

  def initialize(source, attributes = {})
    @source = source
    super({ name: I18n.t("admin.conference.clone.default_name", name: source.name), slug: "#{source.slug}-copy" }.merge(attributes))
  end

  def save
    return false unless valid?

    @conference = source.dup
    conference.assign_attributes(name: name, slug: slug, start_date: start_date, end_date: end_date, status: :draft, published: false)
    day_offset = (start_date - source.start_date).to_i

    Conference.transaction do
      conference.save!
      source.sessions.includes(:session_speakers).each do |original|
        session = original.dup
        session.conference = conference
        session.status = :draft
        session.starts_at = original.starts_at.in_time_zone(source.venue.time_zone).advance(days: day_offset)
        session.ends_at = original.ends_at.in_time_zone(source.venue.time_zone).advance(days: day_offset)
        session.save!

        if include_speakers
          original.session_speakers.each do |assignment|
            session.session_speakers.create!(speaker_id: assignment.speaker_id)
          end
        end
      end
    end

    true
  rescue ActiveRecord::RecordInvalid => error
    errors.add(:base, I18n.t("admin.conference.clone.invalid_copy", errors: error.record.errors.full_messages.to_sentence))
    false
  rescue ActiveRecord::RecordNotUnique
    errors.add(:slug, :taken)
    false
  end

  private

  def end_date_on_or_after_start_date
    errors.add(:end_date, :before_start_date) if start_date && end_date && end_date < start_date
  end

  def unique_slug
    errors.add(:slug, :taken) if slug.present? && Conference.exists?(slug: slug)
  end
end
