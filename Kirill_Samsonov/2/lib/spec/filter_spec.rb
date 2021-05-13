# frozen_string_literal: true

require_relative '../filter'

describe Filter do
  subject { Filter.new(options) }

  let(:no_subdomains) do
    [
      instance_double('Domain', name: 'mydomain.com', subdomain?: false),
      instance_double('Domain', name: 'mynewdomain.com', subdomain?: false),
      instance_double('Domain', name: 'mynewdomain2.com', subdomain?: false),
      instance_double('Domain', name: 'mydomain.com', subdomain?: false)
    ]
  end

  let(:domains) do
    [
      *no_subdomains,
      instance_double('Domain', name: 'a.mydomain.com', subdomain?: true)
    ]
  end

  context 'without filters' do
    let(:options) { {} }

    it "don't change domains list" do
      expect(subject.filter_domains(domains)).to eq domains
    end
  end

  context 'with no_subdomains option' do
    let(:options) { { no_subdomains: true } }

    it 'remains only first level domains' do
      expect(subject.filter_domains(domains)).to eq no_subdomains
    end
  end
end
