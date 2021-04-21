# frozen_string_literal: true

require_relative 'printer/response_printer'

module Checker
  class Printer
    def initialize(responses)
      @responses = responses
      @total = { total: 0, success: 0, failed: 0, errored: 0 }
    end

    def call
      urls = ResponsePrinter.print(responses)
      total = prepare_total
      puts [urls, total].join("\n\n")
    end

    private

    attr_reader :responses, :total

    def total_result
      @total_result ||= responses.each_with_object(total) do |res, acc|
        acc[res.status] += 1
        acc[:total] += 1
      end
    end

    def prepare_total
      [
        "Total: #{total_result[:total]}",
        "Success: #{total_result[:success]}",
        "Failed: #{total_result[:failed]}",
        "Errored: #{total_result[:errored]}"
      ].join(', ')
    end
  end
end
