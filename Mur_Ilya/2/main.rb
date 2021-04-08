require 'csv'
require 'httparty'
require 'optparse'
require_relative 'lib/csv_reader'
require_relative 'lib/request_collector'
require_relative 'lib/request'

options = {}
OptionParser.new do |opts|
  opts.banner = 'Usage: csv-parser [options]'
  opts.on('--no-subdomains', 'Filter by subdomain') do |sb|
    options[:subdomains] = sb
  end
  opts.on('--exclude-solutions', 'Filter by opensource') do |os|
    options[:solutions] = os
  end
  opts.on('--filter=WORD', 'Filter by word') do |f|
    options[:filterword] = f
  end
end.parse!

if ARGV.first.nil?
  abort 'You must select a csv-file as an argument'
elsif !File.exist?(ARGV.first)
  abort "Can't locate a file"
end

csv_path = File.join(__dir__, ARGV.first)

reader = CSVReader.new(csv_path)

collection = if options.key?(:subdomains)
               RequestCollector.send_requests(reader.filter_by_domains)

             elsif options.key?(:filterword)
               RequestCollector.send_requests(reader.csv_rows, options[:filterword])

             elsif options.key?(:solutions)
               os_path = File.join(__dir__, 'data', 'os.csv')
               RequestCollector.send_requests(reader.filter_by_opensourse(os_path))

             else
               RequestCollector.send_requests(reader.csv_rows)
             end

puts '*' * 80, collection.summary
