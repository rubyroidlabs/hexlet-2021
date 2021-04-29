# frozen_string_literal: true

module Checker
  class Print
    def initialize
      @errored = 0
      @failed = 0
      @successes = 0
      @total = 0
    end

    def to_s
      "Total: #{@total}, Success: #{@successes}, Failed: #{@failed}, Errored: #{@errored}"
    end

    def logger(response)
      @errored += 1 if response.errored?
      @failed += 1 if  response.failed?
      @successes += 1 if response.successes?
      @total += 1
      status = response.failed? ? 'Failed' : response.res.code
      console_print("#{response.host} - #{status} (#{response.time}ms)")
    end

    def console_print(message)
      puts message
    end
  end
end
