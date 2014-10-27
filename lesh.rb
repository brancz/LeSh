require 'sinatra/base'
require 'sinatra/json'
require 'json'
require 'data_mapper'

DataMapper.setup(:default, ENV['DATABASE_URL'] || 'sqlite::memory:')
require './models/link'
DataMapper.finalize.auto_upgrade!

module LeSh
  class App < Sinatra::Base
    helpers Sinatra::JSON

    get '/' do
      File.read(File.join('public', 'index.html'))
    end

    get '/:id' do
      on_link(lambda { |link| redirect link.uri } )
    end

    get '/api/links/:id' do
      on_link(lambda { |link| json link } )
    end

    post '/api/links' do
      uri = JSON.parse(request.body.read.to_s)['uri']
      link = Link.new(uri: uri, created_at: Time.now)
      unless link.save
        status 422
        return json(errors: link.errors.full_messages)
      end
      status 201
      json(link)
    end

    def on_link(code)
      begin
        link = Link.by_string_id params[:id]
        code.call(link)
      rescue DataMapper::ObjectNotFoundError
        status 404
        json({errors: ['Uri could not be found']})
      end
    end
  end
end

module LeSh
  def base_url
    ENV['BASE_URL'] || 'http://localhost:5000/'
  end

  module_function :base_url
end
