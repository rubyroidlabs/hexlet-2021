# frozen_string_literal: true

RSpec.describe Checker::Filter do
  subject { Checker::Filter.new(opts) }
  let(:coll) { CSV.read('./spec/fixtures/rails.csv').flatten }
  describe '#exclude_opensource' do
    let(:opts) { { exclude_solutions: true } }
    let(:expected) { CSV.read('./spec/fixtures/filter_exclude_solutions.csv').flatten }
    it 'return filtred data' do
      expect(subject.filter_hosts(coll)).to eq(expected)
    end
  end
  describe '#exclude_subdomains' do
    let(:opts) { { no_subdomains: true } }
    let(:expected) { CSV.read('./spec/fixtures/filter_exclude_subdomains.csv').flatten }
    it 'return filtred data' do
      expect(subject.filter_hosts(coll)).to eq(expected)
    end
  end
end
