require 'rspec'

require_relative '../lib/ping'

describe 'Requests with different filters' do
  ok_file_path = File.expand_path('../data/rails_test_200.csv', __dir__)
  opensource_file_path = File.expand_path('../data/rails_test_opensource.csv', __dir__)

  subdomains_ping = Ping.new(ok_file_path, { subdomains: true })
  opensource_ping = Ping.new(opensource_file_path, { opensource: true })
  concurrent_ping = Ping.new(opensource_file_path, { parallel: '3' })

  subdomains_ping.run
  it 'should 1 response' do
    expect(subdomains_ping.responses.count).to eq 1
  end
  it 'should OK msg' do
    expect(subdomains_ping.responses.at(0).msg).to eq 'OK'
  end
  it 'should 200 HTTP status' do
    expect(subdomains_ping.responses.at(0).code).to eq 200
  end
  opensource_ping.run
  it 'should empty response' do
    expect(opensource_ping.responses.count).to eq 0
  end
  concurrent_ping.run
  it 'should 3 threads' do
    expect(concurrent_ping.pool_size).to eq 3
  end
end

describe 'Request with keyword filter' do
  ok_file_path = File.expand_path('../data/rails_test_200.csv', __dir__)
  filter_ping = Ping.new(ok_file_path, { filter: 'WINNIEPOOH' })
  filter_ping.run
  it 'should not find a keyword = WINNIEPOOH' do
    total = filter_ping.responses.count
    expect(total).to eq 0
  end
end

describe 'Summary testing' do
  summary_file_path = File.expand_path('../data/rails_test_summary.csv', __dir__)
  summary_ping = Ping.new(summary_file_path, {})
  summary_ping.run

  it 'should summary equals' do
    total = summary_ping.responses.count
    succeeded = summary_ping.responses.select(&:success?)
    errored = summary_ping.responses.select(&:error?)
    failed = summary_ping.responses.select(&:fail?)
    expect(total).to eq 4
    expect(errored.count).to eq 1
    expect(succeeded.count).to eq 2
    expect(failed.count).to eq 1
    expect(errored.at(0).time).to eq nil
    expect("Total: #{total}, Success: #{succeeded.count}, Failed: #{failed.count}, Errored: #{errored.count}").to eq 'Total: 4, Success: 2, Failed: 1, Errored: 1'
  end
end

describe 'ArgumentError testing' do
  ok_file_path = File.expand_path('../data/rails_test_200.csv', __dir__)
  ping = Ping.new(ok_file_path, { })
  ping.run
  it 'file exists?' do
    expect { ping.file_exist?('xxxxx.csv') }.to raise_error(ArgumentError)
  end

  it 'it should not Integer' do
    expect { Ping.new(ok_file_path, { parallel: 'qwerty' }) }.to_not raise_error(ArgumentError)
  end
end
