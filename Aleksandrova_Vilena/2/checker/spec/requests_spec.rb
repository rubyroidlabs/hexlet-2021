# frozen_string_literal: true

require 'rspec'

require_relative '../lib/ping'

describe 'Ping with --subdomains filter' do
  describe '#run' do
    file_path = File.expand_path('../data/rails_test_200.csv', __dir__)
    subdomains_ping = Ping.new(file_path, subdomains: true)
    subdomains_ping.run
    it '1 response' do
      expect(subdomains_ping.responses.count).to eq 1
    end
    it 'OK msg' do
      expect(subdomains_ping.responses.at(0).msg).to eq 'OK'
    end
    it '200 HTTP status' do
      expect(subdomains_ping.responses.at(0).code).to eq 200
    end
  end
end

describe 'Ping with --opensource filter' do
  describe '#run' do
    file_path = File.expand_path('../data/rails_test_opensource.csv', __dir__)
    opensource_ping = Ping.new(file_path, opensource: true)
    opensource_ping.run
    it 'empty response' do
      expect(opensource_ping.responses.count).to eq 0
    end
  end
end

describe 'Ping concurrently' do
  describe '#run' do
    file_path = File.expand_path('../data/rails_test_opensource.csv', __dir__)
    concurrent_ping = Ping.new(file_path, parallel: '3')
    concurrent_ping.run
    it 'checks the number of threads' do
      expect(concurrent_ping.pool_size).to eq 3
    end
  end
end

describe 'Ping with a keyword' do
  describe '#run' do
    file_path = File.expand_path('../data/rails_test_200.csv', __dir__)
    filter_ping = Ping.new(file_path, filter: 'WINNIEPOOH')
    filter_ping.run
    it 'did not find a keyword = WINNIEPOOH' do
      total = filter_ping.responses.count
      expect(total).to eq 0
    end
  end
end

describe 'Ping with summary check' do
  file_path = File.expand_path('../data/rails_test_summary.csv', __dir__)
  summary_ping = Ping.new(file_path, {})
  summary_ping.run

  describe '#run' do
    it 'should summary equals' do
      total = summary_ping.responses.count
      succeeded = summary_ping.responses.select(&:success?)
      errored = summary_ping.responses.select(&:error?)
      failed = summary_ping.responses.select(&:fail?)
      expect(total).to eq 4
      expect(errored.count).not_to eq 0
      expect(succeeded.count).to eq 2
      expect(failed.count).to eq 1
      expect(errored.at(0).time).to eq nil
    end
  end
end

describe 'Ping' do
  file_path = File.expand_path('../data/rails_test_200.csv', __dir__)
  ping = Ping.new(file_path, {})
  ping.run
  describe '#file_exists?' do
    it 'file does not exist' do
      expect { ping.file_exist?('xxxxx.csv') }.to raise_error(ArgumentError)
    end
  end
end
