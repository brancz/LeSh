describe Link do
  it 'should not be valid when the uri is not set' do
    link = Link.new
    expect(link.valid?).to be_falsey
    expect(link.errors.full_messages.first).to eq('Uri must not be blank')
  end

  it 'should not be valid when the uri is invalid' do
    link = Link.new uri: 'arodwfuft'
    expect(link.valid?).to be_falsey
    expect(link.errors.full_messages.first).to eq('Uri has an invalid format')
  end

  it 'should be valid when the uri is valid' do
    link = Link.new uri: 'http://google.com/'
    expect(link.valid?).to be_truthy
  end

  it 'should be valid when the uri is valid' do
    link = Link.new id: 1, uri: 'http://google.com/'
    result = JSON.pretty_generate({
      uri: "http://google.com/",
      internal_uri: "http://localhost:5000/1",
      internal_api_uri: "http://localhost:5000/api/links/1"
    })
    expect(link.to_json).to eq result
  end

  it 'generates the correct urls' do
    link = Link.new id: 10, uri: 'http://google.com/'
    expect(link.internal_uri).to eq 'http://localhost:5000/A'
    expect(link.internal_api_uri).to eq 'http://localhost:5000/api/links/A'
  end
end
