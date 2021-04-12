# frozen_string_literal: true

require 'checker'

# rubocop:disable Metrics/BlockLength
describe Checker::Application do
  describe 'application run' do
    let(:filepath) { 'spec/fixtures/application.csv' }
    let(:url_ok) { '200.com' }
    let(:url_failed) { '500.com' }
    let(:url_error) { 'error-url.com' }

    context 'correctly' do
      before do
        stub_valid_request("https://#{url_ok}", 200)
        stub_valid_request("https://#{url_failed}", 500)
        stub_error_request("https://#{url_error}", 'err')
      end

      it 'in one thread' do
        expect(subject.call(filepath)).to match_array(
          [
            have_attributes(url: url_ok, status: :success),
            have_attributes(url: url_failed, status: :failed),
            have_attributes(url: url_error, status: :errored, message: 'err')
          ]
        )
      end

      it 'in parallel threads' do
        expect(Checker::Application.new(parallel: 5)
          .call(filepath)).to match_array(
            [
              have_attributes(url: url_ok, status: :success),
              have_attributes(url: url_failed, status: :failed),
              have_attributes(url: url_error, status: :errored, message: 'err')
            ]
          )
      end
    end

    context 'with errors' do
      it 'wrong filepath' do
        no_file_path = 'spec/fixtures/rai.csv'
        expect { subject.call(no_file_path) }
          .to raise_error(ArgumentError, 'no such a file')
      end

      it 'parser not exist' do
        no_parser_path = 'spec/fixtures/filter.json'
        expect { subject.call(no_parser_path) }
          .to raise_error('no such a parser')
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
