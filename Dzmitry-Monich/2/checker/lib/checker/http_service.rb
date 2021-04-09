require 'uri'
require 'faraday'
# require 'faraday_middleware'
require 'ostruct'

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

    def request(links)
      links.map(&method(:process_link))
    end

    def parallel_request(links, count)
      responses = []
      chunk_size = links.size / count + 1
      threads = []

      links.each_slice(chunk_size) do |chunk|
        threads << Thread.new(chunk) do |c|
          c.each { |url| responses << method(:process_link).call(url) }
        end
      end
      threads.each(&:join)

      responses
    end

    def process_link(link)
      start = Time.now
      res = client.get(prepared_link(link))
      OpenStruct.new({ url: link,
                       status: res.status >= 400 ? :failed : :success,
                       response: res,
                       interval: Time.now - start })
    rescue StandardError => e
      OpenStruct.new({ url: link,
                       status: :errored,
                       message: e.message })
    end
  end
end
