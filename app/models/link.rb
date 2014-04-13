class Link < ActiveRecord::Base

  URL_REGEX = Regexp.new(URI::regexp, Regexp::IGNORECASE)

	before_validation :escape_uri, on: :create

	validates :uri, presence: true
	validates :uri, format: { with: URL_REGEX }
	validate :is_uri?

	def escape_uri
		if self.uri
			self.uri = URI::escape(self.uri)
		end
	end

	def is_uri?
		begin
			URI.parse(self.uri)
		rescue
			errors.add(:uri, "is invalid")
		end
	end
end
