# frozen_string_literal: true

require 'uri'
require 'faraday'
require 'ostruct'
require 'async'

module Checker
  class HttpService
    def initialize(links, threads_count)
      @client = Faraday.new
      @links = links
      @threads_count = threads_count
    end

    def call
      threads_count ? parallel_request : request
    end

    private

    attr_reader :client, :links, :threads_count

    def prepared_link(link)
      url = URI::HTTP.build(host: link)
      url.scheme = 'https'
      url.to_s
    end

    def request
      Async do |task|
        res = []
        links.each { |url| task.async { res << process_link(url) } }
        res
      end.wait
    end

    def parallel_request
      chunk_size = links.size / threads_count + 1

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

    # Slowest
    # def request(links)
    #   links.map(&method(:process_link))
    # end

    # Not so fast as expected
    # def parallel_request(links, count)
    #   Parallel.map(links, in_threads: count) { |link| process_link(link) }
    # end
  end
end
