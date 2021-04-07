require 'csv'

module Checker
  class Application
    def initialize(options = {})
      @options = options
    end

    def call(filepath)
      abs_path = Checker.root_path.join(filepath)
      ext_type = File.extname(filepath)[1..-1]
      validate(abs_path, ext_type)

      parcers[ext_type].call(abs_path)
    end

    private

    attr_reader :options

    def parcers
      { 'csv' => ->(content) { CSV.read(content).flatten } }
    end

    def validate(filepath, extname)
      raise ArgumentError, 'no such a file' unless File.exist?(filepath)

      raise 'no such a parser' unless parcers.key?(extname)
    end
  end
end
