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

    def call(urls)
      urls.map do |url|
        begin
          start = Time.now
          res = client.get(prepared_url(url))
          OpenStruct.new({ url: url,
                           status: fulfiled_status(res.status),
                           response: res,
                           response_time: Time.now - start })
        rescue StandardError => e
          OpenStruct.new({ url: url,
                           status: 'Errored',
                           message: e.message })
        end
      end
    end

    private

    attr_reader :client

    def prepared_url(url)
      valid_url = URI::HTTP.build(host: url)
      valid_url.scheme = 'https'
      valid_url.to_s
    end

    def fulfiled_status(status_code)
      status_code >= 400 ? 'Failed' : 'Success'
    end
  end
end
