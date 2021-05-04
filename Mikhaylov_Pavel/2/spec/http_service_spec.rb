# frozen_string_literal: true

require_relative '../lib/checker/http_service'
require_relative '../lib/checker/printer'
require_relative '../lib/checker/summary'
require_relative 'vcr_setup'

describe HttpService do
  subject(:urls) { CsvReader.new(File.join(__dir__, 'fixtures', 'example.csv')).data }

  describe '#fetch_all' do
    before { VCR.insert_cassette('example', record: :new_episodes) }

    after { VCR.eject_cassette }

    context 'with parallel option' do
      let(:parallel) { 7 }
      let(:http_service_parallel) { HttpService.new(urls, '', parallel) }

      it 'should fetch with parallel requests' do
        expect(http_service_parallel.fetch_all.size).to eq(6)
      end
    end

    context 'with default options' do
      let(:http_default) { HttpService.new(urls, '', 1) }

      it 'should fetch urls and output it' do
        responses = http_default.fetch_all
        expect do
          Printer.new(responses).print
        end.to output("Total: 6, Success: 4, Failed: 1, Errored: 1\n").to_stdout
      end
    end

    context 'with search word' do
      let(:http_service_with_serch_word) { HttpService.new(urls, 'kittenx', 1) }

      it 'should fetch vk.com' do
        expect(http_service_with_serch_word.fetch_all[0][:url]).to eq('vk.com')
      end

      it 'should not fetch google.com' do
        expect(http_service_with_serch_word.fetch_all[0][:url]).not_to eq('google.com')
      end
    end
  end

  describe '#fetch' do
    before { VCR.insert_cassette('example', record: :new_episodes) }

    after { VCR.eject_cassette }

    context 'with default options' do
      let(:http_service) { HttpService.new(urls, '', 1) }

      it 'should fetch url with error status' do
        fetched_url = http_service.fetch('rara.com')
        expect(fetched_url[:error]).to include('Failed to open TCP connection to rara.com:80')
        expect(fetched_url).to_not include(:time, :code)
      end

      it 'should success fetch url' do
        fetched_url = http_service.fetch('hexlet.io')
        expect(fetched_url[:url]).to include('hexlet.io')
        expect(fetched_url.keys).to eq(%i[url code time])
        expect(fetched_url).to_not include(:error)
      end
    end
  end
end
