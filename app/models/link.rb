class Link < ActiveRecord::Base
	before_validation :ensure_short_route, on: :create

	validates :uri, presence: true
	validates :uri, format: { with: URI::regexp }
	validates :short_route, presence: true
	validates :short_route, uniqueness: true

	def ensure_short_route
		if !self.short_route.nil? || !self.short_route.blank?
			hash = Digest::SHA1.base64digest self.uri + Time.now.to_s
			self.short_route = hash[0, 8]
		end
	end
end
