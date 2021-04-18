# frozen_string_literal: true

require 'celluloid/autostart'
require 'celluloid/pool'
require 'faraday'

module UrlAnalyzer
  class RequestWorker
    include Celluloid

    def send_request(url, timeout: 3)
      Faraday.get(url) do |request|
        request.options.timeout = timeout
      end
    rescue Faraday::ConnectionFailed, Faraday::TimeoutError => e
      puts e.message
    end
  end
end
