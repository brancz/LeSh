require 'base62'
require 'json'

class Link
  include DataMapper::Resource

  property :id,         Serial
  property :uri,        Text
  property :created_at, DateTime

  validates_presence_of :uri
  validates_format_of   :uri, with: /\A#{URI::regexp(['http', 'https'])}\z/

  def to_json(options = {})
    JSON.pretty_generate({
      uri: uri, 
      internal_uri: internal_uri, 
      internal_api_uri: internal_api_uri
    }, options)
  end

  def internal_uri
    "#{LeSh.base_url}#{id.base62_encode}"
  end

  def internal_api_uri
    "#{LeSh.base_url}api/links/#{id.base62_encode}"
  end

  def self.by_string_id(id)
    fail ObjectNotFoundError if id.nil?
    Link.get! id.base62_decode
  end
end
