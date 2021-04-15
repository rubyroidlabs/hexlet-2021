# frozen_string_literal: true

require 'uri'
require 'faraday'
# require 'faraday_middleware'
require 'ostruct'
require 'async'
# require 'parallel'

module Checker
  class HttpService
    def initialize
      @client = Faraday.new
    end

    def call(links, threads_count)
      threads_count ? parallel_request(links, threads_count) : request(links)
    end

    private

    attr_reader :client

    def prepared_link(link)
      url = URI::HTTP.build(host: link)
      url.scheme = 'https'
      url.to_s
    end

    # Slowest
    # def request(links)
    #   links.map(&method(:process_link))
    # end

    # Fastest
    def request(links)
      Async do |task|
        res = []
        links.each { |url| task.async { res << process_link(url) } }
        res
      end.wait
    end

    # A little bit faster
    # def parallel_request(links, count)
    #   Parallel.map(links, in_threads: count) { |link| process_link(link) }
    # end

    # Faster
    def parallel_request(links, count)
      chunk_size = links.size / count + 1

      links.each_slice(chunk_size).map do |chunk|
        Thread.new(chunk) { |c| c.map { |url| process_link(url) } }
      end.flat_map(&:value)
    end

    # rubocop:disable Lint/RedundantCopDisableDirective
    # rubocop:disable Rails/TimeZone
    def process_link(link)
      start = Time.now
      res = client.get(prepared_link(link))
      OpenStruct.new(url: link,
                     status: res.status >= 400 ? :failed : :success,
                     response: res,
                     interval: Time.now - start)
    rescue StandardError => e
      OpenStruct.new(url: link,
                     status: :errored,
                     message: e.message)
    end
    # rubocop:enable Rails/TimeZone
    # rubocop:enable Lint/RedundantCopDisableDirective
  end
end
