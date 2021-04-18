#!/usr/bin/env ruby
# frozen_string_literal: true

# Checker links

require_relative 'lib/options_parser'
require_relative 'lib/reader'

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
