#!/usr/bin/env ruby
require 'optparse'
require_relative './lib/checker'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: main.rb [options]"

  opts.on("-n", "--no-subdomains", "Ignore all subdomains above 2 level") do
    options[:no_subdomains] = true
  end

  opts.on("-e", "--exclude-solutions", "Exclude all opensource solutions") do
    options[:exclude_solutions] = true
  end

  opts.on("-f", "--filter=FILTER", "Filter by keyword provided into filter option") do |v|
    options[:filter] = v
  end
end.parse!

checker = Checker.new(ARGV.first, options)
checker.run