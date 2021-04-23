# frozen_string_literal: true

require_relative '../filter'

describe Filter do
  subject { Filter.new(options) }

  let(:domains) { ['mydomain.com', 'anotherdomain.com', 'o.anotherdomain.com', 'google.com'] }
  let(:no_subdomains) { ['mydomain.com', 'anotherdomain.com','google.com']}

  describe 'without filters' do
    let(:options) { {} }

    it "don't change hosts list" do
      expect(subject.filter_domains(domains)).to eq domains
    end
  end

  describe 'with no_subdomains option' do
    let(:options) { { no_subdomains: true } }

    it 'remains only first level domains' do
      expect(subject.filter_domains(domains)).to eq no_subdomains
    end
  end
end