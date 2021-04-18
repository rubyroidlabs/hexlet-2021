# frozen_string_literal: true

require 'csv'

module UrlAnalyzer
  class Parser
    def self.parse(content, data_format)
      case data_format
      when 'csv'
        csv_parse(content).map(&:first)
      else
        raise StandardError("Unknown data format: #{data_format}")
      end
    end

    def self.csv_parse(content)
      CSV.parse content
    end

    private_class_method :csv_parse
  end
end
