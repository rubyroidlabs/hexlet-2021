#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'logger'

require_relative 'lib/helper'
require_relative 'lib/ping'

options = ArgsParser.parse(ARGV)
ping = Ping.new(ARGV.first, options)
ping.filter(options)
ping.start
