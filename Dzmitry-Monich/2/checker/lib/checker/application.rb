# frozen_string_literal: true

require_relative './logging'

module Checker
  class Application
    include Logging

    def initialize(options = {})
      @options = options
    end

    def call(filepath)
      absolute_path = Checker.root_path.join(filepath)
      validate(absolute_path)

      links = Parser.parse(absolute_path)
      filtered_links = filter_links(links)

      responses = http_responses(filtered_links)

      filtered_responses = filter_urls(responses)
      filtered_responses.each do |res|
        logger.info("#{res.url}: #{res.status}: #{res.interval}")
      end

      filtered_responses
    end

    private

    attr_reader :options

    def validate(filepath)
      raise ArgumentError, 'no such a file' unless File.exist?(filepath)
    end

    def filter_links(links)
      keys = options.select { |_k, v| v == true }.keys
      Filter.filter(links, keys)
    end

    def http_responses(links)
      threads_count = options[:parallel]
      HttpService.new.call(links, threads_count)
    end

    def filter_urls(responses)
      key = options[:filter]
      key ? Filter.filter(responses, key) : responses
    end
  end
end
