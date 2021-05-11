# frozen_string_literal: true

require_relative 'lib/machinery'
require 'pry'

command_line = CliParser.new do |opts|
  opts.banner = "Usage: #{__FILE__} [options] FILENAME"
  opts.separator ''
  opts.separator 'Available options:'
  opts.on('--no-subdomains', 'Exclude entries with subdomains', TrueClass)
  opts.on('--filter=WORD', 'Filter out results containing WORD in page body', String)
  opts.on('--exclude-solutions', 'Exclude common open-source solutions', TrueClass)
end

command_line.parse!

domain_list_filename = command_line.args.first

if domain_list_filename.nil? || !File.exist?(domain_list_filename)
  print command_line.usage
  exit
end

domains = DomainsList.new(domain_list_filename, command_line.options)

domains.process! do |percent, domain|
  print "\e[1000D\e[0K#{percent}% complete – now checking #{domain}"
end
print "\e[1000D\e[0K"
domains.results.each { |r| puts r }
puts ''
puts domains.stats
