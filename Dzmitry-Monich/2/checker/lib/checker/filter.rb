# frozen_string_literal: true

module Checker
  # Filter links and content
  class Filter
    class << self
      CONSTRAINTS = %w[github amazon gitlab].freeze

      def filter(links, keys)
        keys.is_a?(Array) ? filter_links(links, keys) : filter_urls(links, keys)
      end

      private

      def link_filters
        {
          no_subdomains: lambda do |coll|
            coll.map { |link| link.split('.')[-2..-1].join('.') }
          end,
          exclude_solutions: lambda do |coll|
            coll.reject { |link| (link.split('.') & CONSTRAINTS).any? }
          end
        }
      end

      def filter_links(content, keys)
        keys.reduce(content) { |acc, key| link_filters[key].call(acc) }
      end

      def filter_urls(content, keys)
        content.select do |res|
          res.status == :success && res.response.body.include?(keys)
        end
      end
    end
  end
end
