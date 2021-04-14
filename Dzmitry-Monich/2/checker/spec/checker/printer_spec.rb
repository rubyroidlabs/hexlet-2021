# frozen_string_literal: true

require 'checker'

describe Checker::Printer do
  let(:url_successed) do
    OpenStruct.new(
      status: :success,
      response: OpenStruct.new(status: 200),
      url: 'ruby.com',
      interval: 0.678822
    )
  end
  let(:url_failed) do
    OpenStruct.new(
      status: :failed,
      response: OpenStruct.new(status: 301),
      url: 'php.com',
      interval: 1.026636
    )
  end
  let(:url_errored) { OpenStruct.new(status: :errored, message: 'getaddrinfo', url: 'java.com') }
  let(:responses) { [url_successed, url_failed, url_errored] }

  it 'Printer outputs results correctly' do
    expected = "ruby.com - 200 (679ms)\nphp.com - 301 (1027ms)\n" \
      "java.com - ERROR (getaddrinfo)\n\n" \
      "Total: 3, Success: 1, Failed: 1, Errored: 1\n"

    expect { Checker::Printer.print(responses) }.to output(expected).to_stdout
  end
end
