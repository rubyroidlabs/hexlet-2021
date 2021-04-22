# frozen_string_literal: true

require 'csv'

module Checker
  class Parser
    class << self
      def parse(filepath)
        ext_type = File.extname(filepath)[1..]
        validate(ext_type)

        parsers.fetch(ext_type).call(filepath)
      end

      private

      def validate(type)
        raise "no parser for this type: #{type}" unless parsers.key?(type)
      end

      def parsers
        { 'csv' => ->(filepath) { CSV.read(filepath).flatten } }
      end
    end
  end
end
