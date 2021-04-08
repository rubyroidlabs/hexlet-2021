require 'request_collector'
require 'httparty'
require 'request'

describe RequestCollector do
  let(:resources) { %w[google.com linux.org] }
  let(:collector) { RequestCollector.send_requests(resources) }

  describe '#send_requests' do
    it 'should correctly send requests' do
      expect(collector.requests.size).to eq 2
    end
  end
  describe '#send_requests' do
    it 'should correctly filter by word' do
      collector_by_word = RequestCollector.send_requests(resources, 'ubuntu')
      expect(collector_by_word.requests.map(&:uri)).to match_array ['linux.org']
    end
  end

  describe '#summary' do
    it 'should return a summary string' do
      expect(collector.summary).to eq 'Total: 2, Success: 2, Failed: 0, Errored: 0'
    end
  end
end
