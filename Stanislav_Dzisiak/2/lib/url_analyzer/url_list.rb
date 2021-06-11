# frozen_string_literal: true

module UrlAnalyzer
  module UrlList
    ORG_URL_PATTERNS = [
      /.org$/i,
      /github.com$/i,
      /gitlab.com$/i
    ].freeze
    DEFAULT_SCHEME = 'http'

    def self.filter(urls, options)
      excluded_patterns = []
      excluded_patterns.push(/\..*\./) if options[:no_subdomains]
      excluded_patterns.concat(ORG_URL_PATTERNS) if options[:exclude_solutions]

      filtered_urls =
        if excluded_patterns.empty?
          urls
        else
          urls.reject do |url|
            excluded_patterns.any? { |pattern| url.match? pattern }
          end
        end

      normalize(filtered_urls)
    end

    def self.normalize(urls)
      urls.map! do |url|
        url.match?(%r{^(?!.+://).*}) ? "#{DEFAULT_SCHEME}://#{url}" : url
      end
    end
  end
end
