class Link < ActiveRecord::Base
	before_validation :escape_uri, on: :create

	validates :uri, presence: true
	validates :uri, format: { with: URI::regexp }
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
