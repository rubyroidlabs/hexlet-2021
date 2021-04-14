# frozen_string_literal: true

require 'optparse'
require 'csv'
require_relative 'lib/csv_reader'
require_relative 'lib/filter'
require_relative 'lib/http_service'

options = {}
OptionParser.new do |opts|
  opts.banner = 'Usage: csv-file [options]'
  opts.on('--no-subdomains', 'Ignore all subdomens') do |sb|
    options[:subdomains] = sb
  end
  opts.on('--filter=WORD', 'Find all pages with selected "WORD"') do |w|
    options[:filterword] = w
  end
  opts.on('--exclude-solutions', 'Ignore opensource projects') do |os|
    options[:solutions] = os
  end
end.parse!

if ARGV.first.nil?
  raise 'Select a csv file'
elsif !File.exist?(ARGV.first)
  raise 'Select a csv file'
end

csv_path = File.join(__dir__, ARGV.first)

csv = CsvReader.new(csv_path)
filtered = Filter.new(csv.data, options).filtered_data
stop_word = options.fetch(:filterword, '')
responses = HttpService.new(filtered).responses(stop_word)
puts responses
