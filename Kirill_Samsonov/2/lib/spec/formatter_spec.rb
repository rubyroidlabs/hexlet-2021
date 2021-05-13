# frozen_string_literal: true

require_relative '../formatter'

describe Formatter do
  subject { Class.new.extend Formatter }

  let(:result) do
    { domain: 'domain.com', status: 200, latency: 1500 }
  end

  it 'format valid domain result' do
    result_string = 'domain.com - 200 (1500ms)'
    expect(subject.format_domain_result(result)).to eq result_string
  end

  it 'format error result' do
    result[:error] = true
    result[:message] = '(Some error has happened)'
    result_error_string = 'domain.com - ERROR: (Some error has happened)'
    expect(subject.format_domain_result(result)).to eq result_error_string
  end
end
