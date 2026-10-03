# frozen_string_literal: true

module ApplicationHelper
	def format_time(time, format: :admin_custom, time_zone: "UTC")
		return if time.blank?

		I18n.l(time.in_time_zone(time_zone), format: format) if time
	end
end
