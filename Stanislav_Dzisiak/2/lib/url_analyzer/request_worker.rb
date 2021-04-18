# frozen_string_literal: true

require 'celluloid/autostart'
require 'celluloid/pool'
require 'faraday'
require 'benchmark'

module UrlAnalyzer
  class RequestWorker
    include Celluloid

    def send_request(url, timeout: 3)
      result = { url: url }

      begin
        response = nil
        time = Benchmark.measure do
          response = Faraday.get(url) do |request|
            request.options.timeout = timeout
          end
        end
        result[:time] = (time.real * 1000).round
        result[:status] = response.status
        result[:body] = response.body
      rescue Faraday::ConnectionFailed, Faraday::TimeoutError => e
        result[:error] = e.message
      end

      result
    end
  end
end
