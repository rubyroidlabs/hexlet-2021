# frozen_string_literal: true

require 'celluloid/autostart'
require 'celluloid/pool'
require 'faraday'
require 'benchmark'

module UrlAnalyzer
  class RequestWorker
    include Celluloid

    def self.send_requests(urls, head_only, pool_size)
      request_pool = pool(size: pool_size)

      urls.map do |url|
        request_pool.future.send_request(url, head_only)
      end
    end

    def send_request(url, head_only, timeout = 3)
      http_verb = head_only ? :head : :get
      result = { url: url }

      begin
        response = nil
        time = Benchmark.measure do
          configure_request = proc { |request| request.options.timeout = timeout }
          response = Faraday.method(http_verb).call url, &configure_request
        end
        result[:time] = (time.real * 1000).round
        result[:status] = response.status
        result[:body] = response.body
      rescue StandardError => e
        result[:error] = e.message
      end

      result
    end
  end
end
