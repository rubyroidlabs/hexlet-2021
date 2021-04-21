# frozen_string_literal: true

require_relative '../lib/checker/request'
require_relative 'helpers'

describe Checker::Request do
  before do
    stub_request(:get, 'git.mnt.ee').to_return(body: 'its body!', status: 200)
    stub_request(:get, 'ralphonrails.com').to_raise('unknown error')
    stub_request(:get, 'xulu.gitlab.com').to_return(status: 404)
  end

  describe 'success' do
    let(:request) { Checker::Request.new('git.mnt.ee') }

    it 'has body' do
      expect(request.content).to eq('its body!')
    end

    it 'can succeed' do
      expect(request.success?).to eq(true)
    end
  end

  describe 'failed' do
    let(:request) { Checker::Request.new('xulu.gitlab.com') }

    it 'can fail' do
      expect(request.failed?).to eq(true)
    end
  end

  describe 'error' do
    let(:request) { Checker::Request.new('ralphonrails.com') }

    it 'has error message' do
      expect(request.error_message).to eq('unknown error')
    end

    it 'can error' do
      expect(request.error?).to eq(true)
    end
  end
end
