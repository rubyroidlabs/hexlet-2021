# frozen_string_literal: true

require 'csv'
require_relative 'config'

# Csv parser
module CsvParser
    attr_reader :data
  
    # @param [Object] file_path
    def initialize_csv(file_path, _options)
      @data = CSV.read(file_path).map(&:join)
    end
  
    # @param [Object] options
    def filter(options)
      logger.debug "filtering with options: #{options}"
      @data = data.reject { |k| k.count('.') > 1 } if options.key?(:subdomains)
      @data = filter_opensource(@data) if options.key?(:opensource)
    end
  
    def filter_opensource(data)
      open_source_data = Config.get('OpenSource').map(&:downcase)
      data.reject! do |x|
        open_source_data.find { |t| x.include?(t) }
      end
    end
  end
  