require 'request'

describe Request do
  let(:request) { Request.new(uri: 'google.com', status: 200, time: '250ms') }
  let(:error_request) { Request.new(uri: 'google.com', status: 'ERROR') }

  it 'should assign variables' do
    expect(request.uri).to eq 'google.com'
    expect(request.status).to eq 200
    expect(request.time).to eq '250ms'
  end

  describe '#to_s' do
    it 'should return a correct string' do
      expect(request.to_s).to eq 'google.com - 200 250ms'
    end
  end

  describe '#error?' do
    it 'should return right boolean' do
      expect(request.error?).to be_falsey
      expect(error_request.error?).to be_truthy
    end
  end

  describe '#fail?' do
    it 'should return right boolean' do
      fail_request = Request.new(uri: 'google.com', status: 404, time: '250ms')
      expect(request.fail?).to be_falsey
      expect(fail_request.fail?).to be_truthy
    end
  end

  describe '#success?' do
    it 'should return right boolean' do
      expect(request.success?).to be_truthy
      expect(error_request.success?).to be_falsey
    end
  end
end
