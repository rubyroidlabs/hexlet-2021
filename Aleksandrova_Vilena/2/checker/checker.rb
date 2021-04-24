# rubocop:disable Lint/ScriptPermission
#!/usr/bin/env ruby
# frozen_string_literal: true

require 'logger'

require_relative 'lib/args_parser'
require_relative 'lib/ping'

options = {}
begin
  options = ArgsParser.parse(ARGV)
rescue StandardError => e
  e.message
end

file_path = File.join('data', ARGV.first)
ping = Ping.new(file_path, options)
ping.run
# rubocop:enable Lint/ScriptPermission
