# frozen_string_literal: true

require 'net/http'

module Checker
  class Request
    attr_reader :host, :time, :res, :failed_message

    def initialize(host)
      @host = host
      @failed = false
    end

    def get(path = '/', max_attempts = 3)
      start_time = Time.now.utc
      attempt = 0
      @res = Net::HTTP.get_response(@host, path)
      while attempt <= max_attempts && @res.code == '301'
        @res = Net::HTTP.get_response(URI.parse(res['location']))
        attempt += 1
      end
      finish_time = Time.now.utc
      @time = time_diff_milli(start_time, finish_time).to_i
    rescue StandardError => e
      @failed_message = e.message
      @failed = true
    end

    def time_diff_milli(start, finish)
      (finish - start) * 1000.0
    end

    def successes?
      return @res.code.to_i.between?(200, 399) unless failed?

      false
    end

    def errored?
      return @res.code.to_i.between?(400, 599) unless failed?

      false
    end

    def failed?
      @failed
    end
  end
end
