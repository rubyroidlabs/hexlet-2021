# frozen_string_literal: true

require_relative '../spec_helper'

# rubocop:disable Metrics/BlockLength
describe UrlAnalyzer::Analyzer, '#analyze' do
  subject(:analyze) do
    path_to_csv = get_fixture_path('example.csv')
    analyzer = described_class.new(path_to_csv, options)
    analyzer.analyze
  end

  let(:options) { {} }

  describe 'requests without body' do
    before { VCR.insert_cassette('example_head') }

    after { VCR.eject_cassette }

    context 'with default options' do
      it { expect(analyze).to eq({ total: 30, success: 22, failed: 3, errored: 5 }) }
    end

    context 'with parallel' do
      let(:options) { { parallel: 10 } }

      it { expect(analyze).to eq({ total: 30, success: 22, failed: 3, errored: 5 }) }
    end

    context 'with no subdomains' do
      let(:options) { { no_subdomains: true } }

      it { expect(analyze).to eq({ total: 17, success: 13, failed: 1, errored: 3 }) }
    end

    context 'with exclude solutions' do
      let(:options) { { exclude_solutions: true } }

      it { expect(analyze).to eq({ total: 21, success: 14, failed: 2, errored: 5 }) }
    end

    context 'with exclude solutions & no subdomains' do
      let(:options) { { exclude_solutions: true, no_subdomains: true } }

      it { expect(analyze).to eq({ total: 12, success: 8, failed: 1, errored: 3 }) }
    end
  end

  describe 'requests with body' do
    before { VCR.insert_cassette('example_get') }

    after { VCR.eject_cassette }

    context 'with filter' do
      let(:options) { { filter: 'copy' } }

      it { expect(analyze).to eq({ total: 4, success: 4, failed: 0, errored: 0 }) }
    end

    context 'with filter & no subdomains' do
      let(:options) { { filter: 'copy', no_subdomains: true } }

      it { expect(analyze).to eq({ total: 2, success: 2, failed: 0, errored: 0 }) }
    end
  end
end
# rubocop:enable Metrics/BlockLength
