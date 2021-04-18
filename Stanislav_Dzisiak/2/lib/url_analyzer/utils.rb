# frozen_string_literal: true

module UrlAnalyzer
  module Utils
    ORG_URL_PATTERNS = [
      /.org$/i,
      /github.com$/i,
      /gitlab.com$/i
    ].freeze

    def self.urls_filter(urls, options)
      excluded_patterns = []
      excluded_patterns.push(/\..*\./) if options[:no_subdomains]
      excluded_patterns.concat(ORG_URL_PATTERNS) if options[:exclude_solutions]

      return urls if excluded_patterns.empty?

      urls.reject do |url|
        excluded_patterns.any? { |pattern| url.match? pattern }
      end
    end
  end
end
