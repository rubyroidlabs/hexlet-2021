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

    def call(links)
      links.map do |link|
        begin
          start = Time.now
          res = client.get(prepared_link(link))
          OpenStruct.new({ url: link,
                           status: url_status(res.status),
                           response: res,
                           interval: Time.now - start })
        rescue StandardError => e
          OpenStruct.new({ url: link,
                           status: :errored,
                           message: e.message })
        end
      end
    end

    private

    attr_reader :client

    def prepared_link(link)
      url = URI::HTTP.build(host: link)
      url.scheme = 'https'
      url.to_s
    end

    def url_status(status_code)
      status_code >= 400 ? :failed : :success
    end
  end
end
