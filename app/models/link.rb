class Link < ActiveRecord::Base
	before_validation :ensure_short_route, on: :create

	validates :uri, presence: true
	validates :uri, format: { with: URI::regexp }
	validates :short_route, presence: true
	validates :short_route, uniqueness: true

	def ensure_short_route
		if self.short_route.nil? || self.short_route.blank?
			require 'base62'
			last_link = Link.last
			next_id = ( last_link.id + 1 ) if last_link
			next_id ||= 0
			self.short_route = next_id.base62_encode
		end
	end
end
