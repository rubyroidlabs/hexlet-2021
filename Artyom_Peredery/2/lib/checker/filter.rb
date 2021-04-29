# frozen_string_literal: true

module Checker
  class Filter
    OPENSOURCE = %w[github gitlab].freeze
    HOST_FILTER = {
      no_word_content: ->(body, word) { body.include?(word) },
      no_subdomains: ->(host) { host.count('.') > 1 },
      no_opensource: ->(host) { OPENSOURCE.any? { |w| host.include?(w) } }
    }.freeze
    def initialize(options)
      @options = options
      @exclude_solutions = options[:exclude_solutions]
      @no_subdomains = options[:no_subdomains]
      @filter_word = options[:filter_word]
    end

    def filter_hosts(coll)
      exclude_opensource(coll) unless @options[:exclude_solutions].nil?
      exclude_subdomains(coll) unless @options[:no_subdomains].nil?

      coll
    end

    def exclude_opensource(coll)
      coll.reject!(&HOST_FILTER[:no_opensource])
    end

    def exclude_subdomains(coll)
      coll.reject!(&HOST_FILTER[:no_subdomains])
    end

    def filter_word(response)
      HOST_FILTER[:no_word_content].call(response.res.body, @filter_word) unless @filter_word.nil? || response.failed?
    end
  end
end
