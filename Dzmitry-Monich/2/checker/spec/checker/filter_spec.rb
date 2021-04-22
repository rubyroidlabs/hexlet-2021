# frozen_string_literal: true

require 'checker'

describe Checker::Filter do
  subject { Checker::Filter.new(opts) }

  describe '#links' do
    let(:filepath) { File.expand_path('../fixtures/filter.csv', __dir__) }
    let(:all_links) { CSV.read(filepath).flatten }

    context 'whithout filter options' do
      let(:opts) { {} }

      it 'not filters data' do
        expect(subject.links(all_links)).to eq all_links
      end
    end

    context 'whith option no-subdomains' do
      let(:opts) { { no_subdomains: true } }
      let(:test_path) { File.expand_path('../fixtures/after_subdomains.csv', __dir__) }

      it 'exludes subdomains' do
        expected = CSV.read(test_path).flatten
        expect(subject.links(all_links)).to eq expected
      end
    end

    context 'whith option exclude-solution' do
      let(:opts) { { exclude_solutions: true } }
      let(:test_path) { File.expand_path('../fixtures/after_constrains.csv', __dir__) }

      it 'exludes open sources' do
        expected = CSV.read(test_path).flatten
        expect(subject.links(all_links)).to eq expected
      end
    end

    context 'whith both filters' do
      let(:opts) { { no_subdomains: true, exclude_solutions: true } }
      let(:test_path) { File.expand_path('../fixtures/after_all_filters.csv', __dir__) }

      it 'filters all' do
        expected = CSV.read(test_path).flatten
        expect(subject.links(all_links)).to eq expected
      end
    end
  end

  describe '#responses' do
    let(:res_errored) { OpenStruct.new(status: :errored) }
    let(:res_empty) { OpenStruct.new(status: :success, response: OpenStruct.new(body: 'no')) }
    let(:res_present) { OpenStruct.new(status: :success, response: OpenStruct.new(body: 'some')) }
    let(:responses) { [res_errored, res_empty, res_present] }

    context 'without filter' do
      let(:opts) { { filter: nil } }

      it 'not filters data' do
        expect(subject.responses(responses)).to eq [res_errored, res_empty, res_present]
      end
    end

    context 'whith filtered data' do
      let(:opts) { { filter: 'some' } }

      it 'finds match' do
        expect(subject.responses(responses)).to eq [res_present]
      end
    end

    context 'whithout filtered data' do
      let(:opts) { { filter: 'none' } }

      it 'not find match' do
        expect(subject.responses(responses)).to eq []
      end
    end
  end
end
