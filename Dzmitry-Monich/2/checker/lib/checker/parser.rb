# frozen_string_literal: true

require 'csv'

module Checker
  class Parser
    class << self
      # rubocop:disable Lint/RedundantCopDisableDirective
      # rubocop:disable Style/SlicingWithRange -- [n..] -> Syntax Error
      def parse(filepath)
        ext_type = File.extname(filepath)[1..-1]
        validate(ext_type)

        parcers[ext_type].call(filepath)
      end
      # rubocop:enable Style/SlicingWithRange
      # rubocop:enable Lint/RedundantCopDisableDirective

      private

      def validate(type)
        raise 'no such a parser' unless parcers.key?(type)
      end

      def parcers
        { 'csv' => ->(content) { CSV.read(content).flatten } }
      end
    end
  end
end
