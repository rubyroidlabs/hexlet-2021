# frozen_string_literal: true

require_relative '../checker'

describe Checker do
  let(:net_response) { instance_double('NetResponse', body: 'body', code: '200') }
  let(:domain) { instance_double(Domain, name: 'domain.com', elapsed_time: 100, check: net_response, subdomain?: false) }

  before do
    allow_any_instance_of(Domain).to receive(:check).and_return(net_response)
    allow_any_instance_of(Domain).to receive(:subdomain?).and_return(false)
    allow_any_instance_of(Domain).to receive(:name).and_return('domain.com')
    allow_any_instance_of(Domain).to receive(:elapsed_time).and_return(100)

    allow_any_instance_of(FileReader).to receive(:read).and_return(['domain.com', 'domain2.com'])
    allow_any_instance_of(Filter).to receive(:filter_domains).and_return([domain, domain])

    allow_any_instance_of(Response).to receive(:skip?).and_return(false)
    allow_any_instance_of(Response).to receive(:success?).and_return(true)
  end

  it 'check domain' do
    checker = Checker.new('./source', {})
    expect(checker).to receive(:print).with(1)
  end
end
