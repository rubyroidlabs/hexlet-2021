# frozen_string_literal: true

require 'csv'

module UrlAnalyzer
  module Utils
    module Parser
      # NOTE: It is possible to add parsers of other formats.
      # For example yaml, json, etc.
      def self.parse(content, data_format)
        case data_format
        when 'csv'
          csv_parse(content).map(&:first)
        else
          raise "Unknown data format: #{data_format}"
        end
      end

      def self.csv_parse(content)
        CSV.parse content
      end
    end
  end
end
