# frozen_string_literal: true

require 'optparse'
# Parser program options
class OptionsParser
  def call
    parse
  rescue OptionParser::InvalidOption, OptionParser::MissingArgument => e
    @options.merge!({ error: e.message })
  end

  private

  def parse
    @options = {}

    OptionParser.new do |opts|
      opts.banner = 'Usage: ckecker.rb [options]'

      opts.on('-e', '--exclude-solutions', 'Ignores solutions all open source') do
        @options[:solutions] = true
      end
      opts.on('-s', '--no-subdomains', 'Ignores all domain names of the second and more levels') do
        @options[:subdomains] = true
      end
      opts.on('-f', '--filter=sales', 'Searches for a specific word in page content') do |word|
        @options[:filter] = word.gsub('=', '')
      end
      @options[:help] = opts.help
    end.parse!
    @options
  end
end
