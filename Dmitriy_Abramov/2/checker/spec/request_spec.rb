# frozen_string_literal: true

require_relative '../lib/checker/request'

describe Checker::Request do
  subject { Checker::Request.new('success.com') }

  before do
    stub_request(:any, ->(_uri) { 200 })
  end

  context 'before performing' do
    it 'has host_name' do
      expect(subject.host_name).to eq 'success.com'
    end

    it 'not success' do
      expect(subject.success?).to eq false
    end

    it 'not failed' do
      expect(subject.failed?).to eq false
    end

    it 'not errored' do
      expect(subject.error?).to eq false
    end
  end

  context 'after performing' do
    before do
      subject.perform
    end

    it 'success' do
      expect(subject.success?).to eq true
    end

    it 'has success code' do
      expect(subject.code).to eq 200
    end
  end
end
