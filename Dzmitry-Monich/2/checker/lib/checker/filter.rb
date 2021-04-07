module Checker
  class Filter
    class << self
      def constraints
        %w[github amazon gitlab]
      end

      def filters
        {
          no_subdomains: ->(coll) { coll.map { |item| item.split('.')[-2..-1].join('.') } },
          exclude_solutions: ->(coll) { coll.reject { |item| (item.split('.') & constraints).any? } }
        }
      end

      def filter(content, keys)
        keys.reduce(content) { |acc, key| filters[key].call(acc) }
      end
    end
  end
end
