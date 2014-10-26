require 'base62'

class Link
  include DataMapper::Resource

  property :id,         Serial
  property :uri,        Text
  property :created_at, DateTime

  validates_presence_of :uri
  validates_format_of   :uri, with: /\A#{URI::regexp(['http', 'https'])}\z/

  def internal_uri
    ENV['BASE_URL'] + id.base62_encode
  end

  def self.by_string_id(id)
    fail ObjectNotFoundError if id.nil?
    Link.get! id.base62_decode
  end
end
