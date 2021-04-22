# frozen_string_literal: true

require_relative '../lib/checker/request'

describe Checker::FilterService do
  subject { Checker::FilterService.new(options) }

  let(:hosts) { ['first.com', 'second.com', 'third.first.com', 'fourth.gitlab.com'] }
  let(:no_subdomains) { ['first.com', 'second.com'] }
  let(:no_solutions) { ['first.com', 'second.com', 'third.first.com'] }

  describe 'without filters' do
    let(:options) { {} }

    it "don't change hosts list" do
      expect(subject.filter_hosts(hosts)).to eq hosts
    end
  end

  describe 'with no_subdomains option' do
    let(:options) { { no_subdomains: true } }

    it "don't change hosts list" do
      expect(subject.filter_hosts(hosts)).to eq no_subdomains
    end
  end

  describe 'without exclude_solution option' do
    let(:options) { { exclude_solutions: true } }

    it "don't change hosts list" do
      expect(subject.filter_hosts(hosts)).to eq no_solutions
    end
  end

  describe 'with filter' do
    let(:options) { { filter: 'body' } }
    let(:request) { instance_double(Checker::Request) }

    before do
      allow(request).to receive(:content).and_return('body')
      allow(request).to receive(:success?).and_return(true)
    end

    it "don't change hosts list" do
      expect(subject.selected_content?(request)).to eq true
    end
  end
end
