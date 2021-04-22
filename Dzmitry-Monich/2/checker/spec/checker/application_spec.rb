# frozen_string_literal: true

require 'checker'

describe Checker::Application do
  let(:filepath) { 'spec/fixtures/application.csv' }
  let(:url_ok) { '200.com' }
  let(:url_failed) { '500.com' }
  let(:url_error) { 'error-url.com' }

  context 'When Application runs correctly' do
    subject { Checker::Application.new(filepath, parallel: parallel) }

    before do
      stub_valid_request("https://#{url_ok}", 200)
      stub_valid_request("https://#{url_failed}", 500)
      stub_error_request("https://#{url_error}", 'err')
    end

    context 'with one thread' do
      let(:parallel) { nil }

      it 'runs correctly' do
        expect(subject.call).to match_array(
          [
            have_attributes(url: url_ok, status: :success),
            have_attributes(url: url_failed, status: :failed),
            have_attributes(url: url_error, status: :errored, message: 'err')
          ]
        )
      end
    end

    context 'with parallel threads' do
      let(:parallel) { 5 }

      it 'runs correctly' do
        expect(subject.call).to match_array(
          [
            have_attributes(url: url_ok, status: :success),
            have_attributes(url: url_failed, status: :failed),
            have_attributes(url: url_error, status: :errored, message: 'err')
          ]
        )
      end
    end
  end

  context 'When Application runs with errors' do
    subject { Checker::Application.new(filepath) }

    context 'if file not exists' do
      let(:filepath) { 'spec/fixtures/rai.csv' }

      it 'raises error' do
        expect { subject.call }
          .to raise_error(ArgumentError, "no file on path: #{filepath}")
      end
    end

    context 'if parser not exists (wrong file extention)' do
      let(:filepath) { 'spec/fixtures/filter.json' }

      it 'raises error' do
        expect { subject.call }
          .to raise_error('no parser for this type: json')
      end
    end
  end
end
