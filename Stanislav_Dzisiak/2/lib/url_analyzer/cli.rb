# frozen_string_literal: true

require 'slop'

module UrlAnalyzer
  class Cli
    @banner = <<~BANNER
      Utility for analyzing urls.
      usage: url-analuzer <path_to_csv> [options]
    BANNER

    def run
      parse_arguments

      analyzer = Analyzer.new @path_to_csv, @options.to_h
      begin
        result = analyzer.analyze
        puts 'The urls has been successfully analyzed.'
        puts '---------------------------------------------'
        puts result
      rescue StandardError => e
        warn "Error: #{e.message}"
        exit 1
      end
    end

    private

    def parse_arguments
      # NOTE: Here the Slop::UnknownOption error may occur when using unknown options.
      # The utility logic allows the use of unspecified options.
      @options = Slop.parse suppress_errors: true do |o|
        o.banner = @banner
        o.separator 'options:'
        o.bool '--no-subdomains', 'check only first level domains'
        o.bool '--exclude-solutions', 'ignore open source projects'
        o.string '--filter', 'find pages containing a word (example: --filter=word)', default: ''
        o.int '--parallel', 'check urls in N streams (example: --parallel=N)', default: 1
        o.separator ''
        o.separator 'other options:'
        o.on('-v', '--version') { puts UrlAnalyzer::VERSION }
        o.on('-h', '--help') { puts o }
      end

      ARGV.replace @options.arguments
      @path_to_csv = ARGV.first
    end
  end
end
