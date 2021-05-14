# frozen_string_literal: true

RSpec.describe Checker::Filter do
  subject { Checker::Filter.new(opts) }

  describe '#exclude_opensource' do
    let(:opts) { { exclude_solutions: true } }
    let(:coll) { ["000010.industry-std.com", "github.com", "gitlab.com", "1.sendvid.com", "1000albergues.com", "agentboca.com", "agentcash.com", "agenturoffice.sunzinet.com", "agilehumanities.ca"] }
    let(:expected) { CSV.read('./spec/fixtures/filter_exclude_solutions.csv').flatten }
    it 'filter' do
      expect(subject.filter_hosts(coll)).to eq(expected)
    end
  end
end