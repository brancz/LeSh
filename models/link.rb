class Link
  include DataMapper::Resource

  property :id,         Serial
  property :uri,        Text
  property :created_at, DateTime
end
