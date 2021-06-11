# frozen_string_literal: true

require 'checker'
require 'link'

describe Checker do
  let(:link) { Link.new('guides.rubyonrails.org') }

  describe '.call' do
    context 'when not options key and link success' do
      it 'change link code, error' do
        Checker.new(link, {}).call

        expect(link.code).to eq(301)
        expect(link.error).to be nil
      end
    end

    context 'when options key equal filter and link success contains the word' do
      it 'change link code' do
        Checker.new(link, filter: 'ruby').call

        expect(link.code).to eq(200)
      end
    end

    context 'when options key equal filter and link success not contains the word' do
      it 'change link code, valid' do
        Checker.new(link, filter: 'php').call

        expect(link.code).to eq(200)
        expect(link.valid).to be false
      end
    end

    context 'when there are valid' do
      it 'add link error' do
        link = Link.new('1234absd.org')
        Checker.new(link, {}).call

        expect(link.error).to eq 'ERROR (getaddrinfo: Name or service not known)'
      end
    end
  end
end
