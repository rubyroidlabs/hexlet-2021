# frozen_string_literal: true

module UrlAnalyzer
  class UrlList
    def initialize(urls)
      @urls = urls.dup
      @operations = []
      @org_url_patterns = [
        /.org$/i,
        /github.com$/i,
        /gitlab.com$/i
      ].freeze
      @default_scheme = 'http'
    end

    def urls
      @operations.each(&:call)
      @operations = []
      @urls
    end

    def filter(options)
      @operations.push lambda {
        excluded_patterns = []
        excluded_patterns.push(/\..*\./) if options[:no_subdomains]
        excluded_patterns.concat(@org_url_patterns) if options[:exclude_solutions]

        return if excluded_patterns.empty?

        @urls.reject! do |url|
          excluded_patterns.any? { |pattern| url.match? pattern }
        end
      }
      self
    end

    def normalize
      @operations.push lambda {
        @urls.map! do |url|
          url.match?(%r{^(?!.+://).*}) ? "#{@default_scheme}://#{url}" : url
        end
      }
      self
    end
  end
end
