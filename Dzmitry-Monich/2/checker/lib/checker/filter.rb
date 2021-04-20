# frozen_string_literal: true

module Checker
  class Filter
    CONSTRAINTS = %w[github amazon gitlab].freeze

    def initialize(options)
      @options = options
    end

    def links(links)
      keys = options.select { |_k, v| v == true }.keys
      keys.reduce(links) { |acc, key| link_filters.fetch(key).call(acc) }
    end

    def responses(responses)
      key = options[:filter]
      if key
        responses.select { |res| res.status == :success && res.response.body.include?(key) }
      else
        responses
      end
    end

    private

    attr_reader :options

    def link_filters
      {
        no_subdomains: ->(coll) { coll.map { |link| link.split('.').last(2).join('.') } },
        exclude_solutions: ->(coll) { coll.reject { |link| (link.split('.') & CONSTRAINTS).any? } }
      }
    end
  end
end
