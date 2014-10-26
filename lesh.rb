require 'sinatra/base'
require 'sinatra/json'
require 'json'
require 'base62'

require './models/link'

module LeSh
  class App < Sinatra::Base
    helpers Sinatra::JSON

    get '/' do
      erb :index
    end

    post '/' do
      uri = JSON.parse(request.body.read.to_s)['uri']
      link = Link.create(uri: uri, created_at: Time.now)
      json uri: link.id.base62_encode
    end

    get '/:id' do
      link = Link.get(params[:id].base62_decode)
      json uri: link.uri
    end
  end
end
