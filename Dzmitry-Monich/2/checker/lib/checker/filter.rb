module Checker
  class Filter
    class << self
      CONSTRAINTS = %w[github amazon gitlab].freeze

      def filter(content, keys)
        keys.is_a?(Array) ? filter_links(content, keys) : filter_urls(content, keys)
      end

      private

      def link_filters
        {
          no_subdomains: ->(coll) { coll.map { |link| link.split('.')[-2..-1].join('.') } },
          exclude_solutions: ->(coll) { coll.reject { |link| (link.split('.') & CONSTRAINTS).any? } }
        }
      end

      def filter_links(content, keys)
        keys.reduce(content) { |acc, key| link_filters[key].call(acc) }
      end

      def filter_urls(content, keys)
        content.select { |res| res.status == :success && res.response.body.include?(keys) }
      end
    end
  end
end
