require 'checker'
require 'ostruct'

describe Checker::Filter do
  describe 'filter links' do
    let(:link) { File.expand_path('../fixtures/rails.csv', __dir__) }
    let(:all_links) { CSV.read(link).flatten }

    it 'without filter' do
      keys = []
      expect(Checker::Filter.filter(all_links, keys)).to eq all_links
    end

    it 'filters via subdomains' do
      keys = [:no_subdomains]
      test_path = File.expand_path('../fixtures/after_subdomains.csv', __dir__)

      expected = CSV.read(test_path).flatten
      expect(Checker::Filter.filter(all_links, keys)).to eq expected
    end

    it 'filters via exclude_solutions' do
      keys = [:exclude_solutions]
      test_path = File.expand_path('../fixtures/after_constrains.csv', __dir__)

      expected = CSV.read(test_path).flatten
      expect(Checker::Filter.filter(all_links, keys)).to eq expected
    end

    it 'filters via all filters' do
      keys = %i[no_subdomains exclude_solutions]
      test_path = File.expand_path('../fixtures/after_all_filters.csv', __dir__)

      expected = CSV.read(test_path).flatten
      expect(Checker::Filter.filter(all_links, keys)).to eq expected
    end
  end

  describe 'filter urls' do
    let(:url_errored) { OpenStruct.new(status: 'Errored') }
    let(:url_empty) { OpenStruct.new(status: 'Success', response: OpenStruct.new(body: 'no')) }
    let(:url_present) { OpenStruct.new(status: 'Success', response: OpenStruct.new(body: 'some')) }
    let(:responses) { [url_errored, url_empty, url_present] }

    it 'without filter' do
      keys = ''
      expect(Checker::Filter.filter(responses, keys)).to eq [url_empty, url_present]
    end

    it 'with filter' do
      keys = 'some'
      expect(Checker::Filter.filter(responses, keys)).to eq [url_present]
    end
  end
end
