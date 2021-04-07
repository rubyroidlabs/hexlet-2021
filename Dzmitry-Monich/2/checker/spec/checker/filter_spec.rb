require 'checker'

describe Checker::Filter do
  describe 'filter urls' do
    let(:url) { File.expand_path('../fixtures/rails.csv', __dir__) }
    let(:all_urls) { CSV.read(url).flatten }

    it 'without filter' do
      keys = []
      expect(Checker::Filter.filter(all_urls, keys)).to eq all_urls
    end

    it 'filters via subdomains' do
      keys = [:no_subdomains]
      test_path = File.expand_path('../fixtures/after_subdomains.csv', __dir__)

      expected = CSV.read(test_path).flatten
      expect(Checker::Filter.filter(all_urls, keys)).to eq expected
    end

    it 'filters via exclude_solutions' do
      keys = [:exclude_solutions]
      test_path = File.expand_path('../fixtures/after_constrains.csv', __dir__)

      expected = CSV.read(test_path).flatten
      expect(Checker::Filter.filter(all_urls, keys)).to eq expected
    end

    it 'filters via all filters' do
      keys = %i[no_subdomains exclude_solutions]
      test_path = File.expand_path('../fixtures/after_all_filters.csv', __dir__)

      expected = CSV.read(test_path).flatten
      expect(Checker::Filter.filter(all_urls, keys)).to eq expected
    end
  end
end
