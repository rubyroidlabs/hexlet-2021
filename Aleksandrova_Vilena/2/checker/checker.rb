#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'logger'

require_relative 'lib/helper'
require_relative 'lib/ping'

options = ArgsParser.parse(ARGV)
file_path = File.join('data', ARGV.first)
ping = Ping.new(file_path, options)
ping.run
