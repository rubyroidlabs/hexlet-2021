require 'optparse'
# require 'csv'

params = {}
OptionParser.new do |opts|
  opts.banner = "Usage: #{__FILE__} [options] FILENAME"
  opts.on('--no-subdomains', 'Exclude entries with subdomains', TrueClass)
  opts.on('--filter=WORD', 'Filter out results containing WORD in page body', String)
  opts.on('--exclude-solutions', 'Exclude common open-source solutions', TrueClass)
end.parse!(into: params)

domain_list_filename = ARGV.first

unless !domain_list_filename.nil? && File.exists?(domain_list_filename)
  fail(ArgumentError, "Domain list filename incorrect or not provided")
end


