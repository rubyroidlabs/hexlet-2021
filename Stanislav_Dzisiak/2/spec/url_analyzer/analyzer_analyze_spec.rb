# frozen_string_literal: true

require_relative '../spec_helper'

def analyze_with(options = {})
  path_to_csv = get_fixture_path 'example.csv'
  analyzer = UrlAnalyzer::Analyzer.new path_to_csv, options
  analyzer.analyze
end

# rubocop:disable Metrics/BlockLength
describe UrlAnalyzer::Analyzer, '#analyze' do
  describe 'requests without body' do
    before { VCR.insert_cassette('example_head') }

    after { VCR.eject_cassette }

    it 'default' do
      data = analyze_with
      expect(data).to eq({ total: 30, success: 22, failed: 3, errored: 5 })
    end

    it 'default with parallel' do
      data = analyze_with parallel: 10
      expect(data).to eq({ total: 30, success: 22, failed: 3, errored: 5 })
    end

    it 'no subdomains' do
      data = analyze_with no_subdomains: true
      expect(data).to eq({ total: 17, success: 13, failed: 1, errored: 3 })
    end

    it 'exclude solutions' do
      data = analyze_with exclude_solutions: true
      expect(data).to eq({ total: 21, success: 14, failed: 2, errored: 5 })
    end

    it 'exclude solutions & no subdomains' do
      data = analyze_with exclude_solutions: true, no_subdomains: true
      expect(data).to eq({ total: 12, success: 8, failed: 1, errored: 3 })
    end
  end

  describe 'requests with body' do
    before { VCR.insert_cassette('example_get') }

    after { VCR.eject_cassette }

    it 'filter' do
      data = analyze_with filter: 'copy'
      expect(data).to eq({ total: 4, success: 4, failed: 0, errored: 0 })
    end

    it 'filter & no subdomains' do
      data = analyze_with filter: 'copy', no_subdomains: true
      expect(data).to eq({ total: 2, success: 2, failed: 0, errored: 0 })
    end
  end
end
# rubocop:enable Metrics/BlockLength
