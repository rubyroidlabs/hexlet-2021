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

      urls = parse_content(absolute_path)
      filtered_urls = filter_urls(urls)
      logger.info("filtered urls: #{filtered_urls}")

      responses = responses(filtered_urls)
      responses.each do |i|
        logger.info("url: #{i.url}")
        logger.info("status: #{i.status}")
        logger.info("time: #{i.response_time}")
        logger.info("code: #{i.response.status}") unless i.status == 'Errored'
      end
    end

    private

    attr_reader :options

    def validate(filepath)
      raise ArgumentError, 'no such a file' unless File.exist?(filepath)
    end

    def parse_content(filepath)
      Parser.parse(filepath)
    end

    def filter_urls(urls)
      keys = options.select { |_k, v| v == true }.keys
      Filter.filter(urls, keys)
    end

    def responses(urls)
      HttpService.new.call(urls)
    end
  end
end
