require 'rspec'

require_relative '../lib/ping'

describe Ping do
  ok_file_path = File.expand_path('../data/rails_test_200.csv', __dir__)
  opensource_file_path = File.expand_path('../data/rails_test_opensource.csv', __dir__)
  summary_file_path = File.expand_path('../data/rails_test_summary.csv', __dir__)

  subdomains_ping = Ping.new(ok_file_path, { subdomains: true })
  opensource_ping = Ping.new(opensource_file_path, { opensource: true })
  concurrent_ping = Ping.new(opensource_file_path, { parallel: '3' })
  summary_ping = Ping.new(summary_file_path, {})
  filter_ping = Ping.new(ok_file_path, { filter: 'WINNIEPOOH' })

  subdomains_ping.run
  it 'should 1 response' do
    expect(subdomains_ping.responses.count).to eq 1
  end
  it 'should OK msg' do
    expect(subdomains_ping.responses.at(0).message).to eq 'OK'
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
    expect(succeeded.at(0).time).to be > 0
    expect(errored.at(0).time).to eq 0
    expect("Total: #{total}, Success: #{succeeded.count}, Failed: #{failed.count}, Errored: #{errored.count}").to eq 'Total: 4, Success: 2, Failed: 1, Errored: 1'
  end
  filter_ping.run
  it 'should not found keyword = WINNIEPOOH' do
    total = filter_ping.responses.count
    expect(total).to eq 0
  end

  begin
    wrong_arg_ping = Ping.new(opensource_file_path, { parallel: 'qwerty' })
    raise ArgumentError, 'argument error'
  rescue StandardError => e
    puts e.message
  end
  it 'should argument error' do
    expect(e.message).to eq 'argument error'
  end
end
