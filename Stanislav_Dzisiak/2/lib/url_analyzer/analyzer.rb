# frozen_string_literal: true

module UrlAnalyzer
  class Analyzer
    def initialize(path_to_csv, options = {})
      @path_to_csv = path_to_csv
      @options = options
    end

    def analyze
      'result'
    end
  end
end
