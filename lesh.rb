require 'sinatra/base'
require 'sinatra/json'
require 'json'
require 'base62'

require './models/link'

module LeSh
  class App < Sinatra::Base
    helpers Sinatra::JSON

    get '/' do
      File.read(File.join('public', 'index.html'))
    end

    get '/:id' do
      id = params[:id]
      link = Link.get(id.base62_decode)
      if link.nil?
        return status 404
      end
      redirect link.uri
    end

    post '/api/links' do
      uri = JSON.parse(request.body.read.to_s)['uri']
      if uri !~ /\A#{URI::regexp(['http', 'https'])}\z/
        return status 422
      end
      link = Link.create(uri: uri, created_at: Time.now)
      json uri: link.id.base62_encode
    end

    get '/api/links/:id' do
      link = Link.get(params[:id].base62_decode)
      if link.nil?
        return status 404
      end
      json uri: link.uri
    end
  end
end
