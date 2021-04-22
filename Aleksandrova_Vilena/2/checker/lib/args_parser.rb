# frozen_string_literal: true

require 'optparse'

# Parser of input arguments
class ArgsParser
  # @param [Object] args
  def self.parse(args)
    options = {}
    OptionParser.new do |opts|
      opts.banner = 'Usage: Ping Util'
      opts.on('-n', '--no-subdomains') { |o| options[:subdomains] = o }
      opts.on('-f', '--filter KEYWORD') { |o| options[:filter] = o }
      opts.on('-r', '--exclude-solutions') { |o| options[:opensource] = o }
      opts.on('-p', '--parallel N') { |o| options[:parallel] = o }
      opts.parse!(args)
    end
    options
  end
end