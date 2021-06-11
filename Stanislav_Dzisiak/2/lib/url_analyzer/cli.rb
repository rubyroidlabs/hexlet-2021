# frozen_string_literal: true

require 'slop'

module UrlAnalyzer
  class Cli
    def run
      options = parse_options
      path_to_csv, = parse_arguments(options)

      analyzer = Analyzer.new(path_to_csv, options.to_h)
      data = analyzer.analyze

      puts '---------------------------------------------'
      puts data_to_s(data)
    rescue StandardError => e
      warn "Error: #{e.message}"
      exit 1
    end

    private

    def data_to_s(data)
      [
        "Total: #{data[:total]}",
        "Success: #{data[:success]}",
        "Failed: #{data[:failed]}",
        "Errored: #{data[:errored]}"
      ].join(', ')
    end

    # rubocop:disable Metrics/MethodLength
    def parse_options
      Slop.parse do |o|
        o.banner =  "Utility for analyzing urls.\nusage: checker <path_to_csv> [options]"
        o.separator 'options:'
        o.bool      '--no-subdomains',     'check only first level domains'
        o.bool      '--exclude-solutions', 'ignore open source projects'
        o.string    '--filter',            'find pages containing a word (example: --filter=word)', default: ''
        o.int       '--parallel',          'check urls in N streams (example: --parallel=N)', default: 1
        o.separator ''
        o.separator 'other options:'
        o.on('-v', '--version') do
          puts VERSION
          exit
        end
        o.on('-h', '--help') do
          puts o
          exit
        end
      end
    end
    # rubocop:enable Metrics/MethodLength

    def parse_arguments(options)
      ARGV.replace options.arguments
      raise 'missing required argument: <path_to_csv>' if ARGV.empty?

      ARGV
    end
  end
end
