# frozen_string_literal: true

require_relative './logging'

module Checker
  class Application
    include Logging

    def initialize(filepath, options = {})
      @absolute_path = Checker.root_path.join(filepath)
      validate(filepath)

      @options = options
    end

    def call
      links = Parser.parse(absolute_path)

      filter = Filter.new(options)
      filtered_links = filter.links(links)
      logger.info("filtered linked: #{filtered_links}")

      responses = HttpService.new(filtered_links, options[:parallel]).call

      filtered_responses = filter.responses(responses)
      filtered_responses.each { |res| logger.info("#{res.url}: #{res.status}: #{res.interval}") }

      filtered_responses
    end

    private

    attr_reader :options, :filepath, :absolute_path

    def validate(filepath)
      raise ArgumentError, "no file on path: #{filepath}" unless File.exist?(absolute_path)
    end
  end
end
