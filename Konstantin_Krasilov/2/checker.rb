#!/usr/bin/env ruby
# frozen_string_literal: true

# Checker links

require_relative 'lib/options_parser'
require_relative 'lib/reader'
require_relative 'lib/checker'

options = OptionsParser.new.call

if options.key?(:error)
  puts "Sorry, an error has occurred - #{options[:error]}\n #{options[:help]}"
  exit
elsif ARGV.first.nil? || !ARGV.first.match?(/.csv$/)
  puts 'Please select the correct CSV file.'
  exit
end

file_path = File.join(__dir__, 'data', ARGV.first)
links = Reader.from_csv(file_path, options)

result = { total: 0, success: 0, failed: 0, errored: 0 }

links.each do |link|
  Checker.new(link, options).call
  next unless link.valid?

  puts link
  result[link.status] += 1
  result[:total] += 1
end

puts '-' * 100
puts "Total: #{result[:total]}, Success: #{result[:success]}, Failed: #{result[:failed]}, Errored: #{result[:errored]}"
