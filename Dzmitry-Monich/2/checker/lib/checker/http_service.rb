# frozen_string_literal: true

require 'uri'
require 'faraday'
# require 'faraday_middleware'
require 'ostruct'
require 'async'

module Checker
  class HttpService
    def initialize
      @client = Faraday.new do |conn|
        # conn.use FaradayMiddleware::FollowRedirects
      end
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

    # def request(links)
    #   links.map(&method(:process_link))
    # end

    def request(links)
      Async do |task|
        res = []
        links.map { |url| task.async { res << method(:process_link).call(url) } }
        res
      end.wait
    end

    def parallel_request(links, count)
      chunk_size = links.size / count + 1

      links.each_slice(chunk_size).map do |chunk|
        Thread.new(chunk) do |c|
          c.map { |url| method(:process_link).call(url) }
        end
      end.flat_map(&:value)
    end

    # rubocop:disable Lint/RedundantCopDisableDirective
    # rubocop:disable Rails::TimeZone
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
    # rubocop:enable Rails::TimeZone
    # rubocop:enable Lint/RedundantCopDisableDirective
  end
end
