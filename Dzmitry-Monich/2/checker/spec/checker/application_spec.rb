# frozen_string_literal: true

require 'checker'

describe Checker::Application do
  let(:filepath) { 'spec/fixtures/application.csv' }
  let(:url_ok) { '200.com' }
  let(:url_failed) { '500.com' }
  let(:url_error) { 'error-url.com' }
  subject { Checker::Application }

  context 'when Application run correctly' do
    before do
      stub_valid_request("https://#{url_ok}", 200)
      stub_valid_request("https://#{url_failed}", 500)
      stub_error_request("https://#{url_error}", 'err')
    end

    it 'in one thread' do
      expect(subject.new(filepath).call).to match_array(
        [
          have_attributes(url: url_ok, status: :success),
          have_attributes(url: url_failed, status: :failed),
          have_attributes(url: url_error, status: :errored, message: 'err')
        ]
      )
    end

    it 'in parallel threads' do
      expect(subject.new(filepath, parallel: 5).call).to match_array(
          [
            have_attributes(url: url_ok, status: :success),
            have_attributes(url: url_failed, status: :failed),
            have_attributes(url: url_error, status: :errored, message: 'err')
          ]
        )
    end
  end

  context 'when Application run with errors' do
    it 'file not exists' do
      no_file_path = 'spec/fixtures/rai.csv'
      expect { subject.new(no_file_path).call }
        .to raise_error(ArgumentError, "no file on path: #{no_file_path}")
    end

    it 'parser not exists (wrong file extention)' do
      no_parser_path = 'spec/fixtures/filter.json'
      expect { subject.new(no_parser_path).call }
        .to raise_error('no parser for this type: json')
    end
  end
end
