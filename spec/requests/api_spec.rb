require 'rack/test'

describe 'LeSh Api' do
  include Rack::Test::Methods

  def app
    LeSh::App
  end

  it 'should redirect correctly when following a generated link' do
    uri = 'http://google.com/'
    post '/api/links', {uri: uri}.to_json, 'CONTENT_TYPE' => 'application/json'
    expect(last_response.status).to eq(201)
    response = JSON.parse last_response.body
    get response['internal_uri']
    expect(last_response.status).to eq(302)
    expect(last_response.location).to eq(uri)
    get response['internal_api_uri']
    response = JSON.parse last_response.body
    expect(last_response.status).to eq(200)
    expect(response['uri']).to eq(uri)
  end

  it 'should be able to retrieve the correct information about a link' do
    uri = 'http://google.com/'
    post '/api/links', {uri: uri}.to_json, 'CONTENT_TYPE' => 'application/json'
    response = JSON.parse last_response.body
    get response['internal_api_uri']
    response = JSON.parse last_response.body
    expect(last_response.status).to eq(200)
    expect(response['uri']).to eq(uri)
  end

  it 'should error with unprocessable entity when the url is malformed' do
    uri = 'blabla'
    post '/api/links', {uri: uri}.to_json, 'CONTENT_TYPE' => 'application/json'
    response = JSON.parse last_response.body
    expect(last_response.status).to eq(422)
    expect(response['errors']).to eq(['Uri has an invalid format'])
  end

  it 'should error with unprocessable entity when the url is empty' do
    post '/api/links', {uri: ''}.to_json, 'CONTENT_TYPE' => 'application/json'
    response = JSON.parse last_response.body
    expect(last_response.status).to eq(422)
    expect(response['errors']).to eq(['Uri must not be blank'])
  end

  it 'should error with unprocessable entity when the url is undefined' do
    post '/api/links', {}.to_json, 'CONTENT_TYPE' => 'application/json'
    response = JSON.parse last_response.body
    expect(last_response.status).to eq(422)
    expect(response['errors']).to eq(['Uri must not be blank'])
  end
end
