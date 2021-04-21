# frozen_string_literal: true

require 'slop'

module UrlAnalyzer
  class Cli
    def initialize
      @banner = <<~BANNER
        Utility for analyzing urls.
        usage: checker <path_to_csv> [options]
      BANNER
    end

    def run
      parse_options
      parse_arguments

      analyzer = Analyzer.new @path_to_csv, @options.to_h
      data = analyzer.analyze

      puts '---------------------------------------------'
      puts format data
    rescue StandardError => e
      warn "Error: #{e.message}"
      exit 1
    end

    private

    def format(data)
      result = "Total: #{data[:total]}"
      result << ", Success: #{data[:success]}"
      result << ", Failed: #{data[:failed]}"
      result << ", Errored: #{data[:errored]}"
      result
    end

    # rubocop:disable Metrics/MethodLength
    def parse_options
      @options = Slop.parse do |o|
        o.banner = @banner
        o.separator 'options:'
        o.bool '--no-subdomains', 'check only first level domains'
        o.bool '--exclude-solutions', 'ignore open source projects'
        o.string '--filter', 'find pages containing a word (example: --filter=word)', default: ''
        o.int '--parallel', 'check urls in N streams (example: --parallel=N)', default: 1
        o.separator ''
        o.separator 'other options:'
        o.on('-v', '--version') do
          puts UrlAnalyzer::VERSION
          exit
        end
        o.on('-h', '--help') do
          puts o
          exit
        end
      end
    end
    # rubocop:enable Metrics/MethodLength

    def parse_arguments
      ARGV.replace @options.arguments
      @path_to_csv = ARGV.first

      raise 'missing required argument: <path_to_csv>' if @path_to_csv.nil?
    end
  end
end
