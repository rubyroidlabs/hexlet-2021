require 'rspec'

require_relative '../lib/ping'

describe Ping do
  ok_file_path = File.expand_path('../data/rails_test_200.csv', __dir__)
  opensource_file_path = File.expand_path('../data/rails_test_opensource.csv', __dir__)

  ping_subdomains = Ping.new(ok_file_path, {:subdomains => true})
  ping_opensource = Ping.new(opensource_file_path, {:opensource => true})
  concurrent_ping = Ping.new(opensource_file_path, {:parallel => "3"})

  ping_subdomains.run
  it 'should 1 response' do
    expect(ping_subdomains.responses.count).to eq 1
  end
  it 'should OK msg' do
    expect(ping_subdomains.responses.at(0).message).to eq 'OK'
  end
  it 'should 200 HTTP status' do
    expect(ping_subdomains.responses.at(0).code).to eq 200
  end
  ping_opensource.run
  it 'should empty response' do
    expect(ping_opensource.responses.count).to eq 0
  end
  concurrent_ping.run
  it 'should 3 threads' do
    expect(concurrent_ping.pool_size).to eq 3
  end

  begin
    wrong_arg_ping = Ping.new(opensource_file_path, {:parallel => "qwerty"})
    raise ArgumentError, 'argument error'
  rescue StandardError => e
  end
  it 'should argument error' do
    expect(e.message).to eq 'argument error'
  end
end
