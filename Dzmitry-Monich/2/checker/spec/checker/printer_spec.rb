# frozen_string_literal: true

require 'checker'

describe Checker::Printer do
  let(:url_successed) { make_domain }
  let(:url_failed) { make_domain }
  let(:url_errored) { make_domain }

  let(:res_successed) do
    OpenStruct.new(
      status: :success,
      response: OpenStruct.new(status: 200),
      url: url_successed,
      interval: 0.678822
    )
  end
  let(:res_failed) do
    OpenStruct.new(
      status: :failed,
      response: OpenStruct.new(status: 301),
      url: url_failed,
      interval: 1.026636
    )
  end
  let(:res_errored) { OpenStruct.new(status: :errored, message: 'getaddrinfo', url: url_errored) }
  let(:responses) { [res_successed, res_failed, res_errored] }

  it 'outputs results correctly' do
    expected = "#{url_successed} - 200 (679ms)\n#{url_failed} - 301 (1027ms)\n" \
      "#{url_errored} - ERROR (getaddrinfo)\n\n" \
      "Total: 3, Success: 1, Failed: 1, Errored: 1\n"

    expect { Checker::Printer.new(responses).call }.to output(expected).to_stdout
  end
end
