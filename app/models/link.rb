class Link < ActiveRecord::Base
	before_validation :escape_uri, on: :create

	validates :uri, presence: true
	validates :uri, format: { with: URI::regexp }

	def escape_uri
		if self.uri
			self.uri = URI::escape(self.uri)
		end
	end
end
