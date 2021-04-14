# frozen_string_literal: true

require 'checker'

describe Checker::Filter do
  subject { Checker::Filter }

  describe 'Links filter' do
    let(:link) { File.expand_path('../fixtures/filter.csv', __dir__) }
    let(:all_links) { CSV.read(link).flatten }

    it 'without filter-options (no filteration)' do
      keys = []
      expect(subject.filter(all_links, keys)).to eq all_links
    end

    it 'exludes subdomains' do
      keys = [:no_subdomains]
      test_path = File.expand_path('../fixtures/after_subdomains.csv', __dir__)

      expected = CSV.read(test_path).flatten
      expect(subject.filter(all_links, keys)).to eq expected
    end

    it 'exludes open sources' do
      keys = [:exclude_solutions]
      test_path = File.expand_path('../fixtures/after_constrains.csv', __dir__)

      expected = CSV.read(test_path).flatten
      expect(subject.filter(all_links, keys)).to eq expected
    end

    it 'uses both filters' do
      keys = %i[no_subdomains exclude_solutions]
      test_path = File.expand_path('../fixtures/after_all_filters.csv', __dir__)

      expected = CSV.read(test_path).flatten
      expect(subject.filter(all_links, keys)).to eq expected
    end
  end

  describe 'Urls filter' do
    let(:url_errored) { OpenStruct.new(status: :errored) }
    let(:url_empty) { OpenStruct.new(status: :success, response: OpenStruct.new(body: 'no')) }
    let(:url_present) { OpenStruct.new(status: :success, response: OpenStruct.new(body: 'some')) }
    let(:responses) { [url_errored, url_empty, url_present] }

    it 'without filter option' do
      keys = ''
      expect(subject.filter(responses, keys)).to eq [url_empty, url_present]
    end

    it 'finds match' do
      keys = 'some'
      expect(subject.filter(responses, keys)).to eq [url_present]
    end

    it 'not find match' do
      keys = 'none'
      expect(subject.filter(responses, keys)).to eq []
    end
  end
end
