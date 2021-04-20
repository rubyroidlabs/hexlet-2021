# frozen_string_literal: true

module Checker
  class Printer
    def initialize(responses)
      @responses = responses
      @total = { total: 0, success: 0, failed: 0, errored: 0 }
    end

    def call
      urls = prepare_urls
      total = prepare_total
      puts [urls, total].join("\n\n")
    end

    private

    attr_reader :responses, :total

    def renderers
      [
        {
          check: ->(status) { %i[success failed].include?(status) },
          fn: ->(res) { "#{res.url} - #{res.response.status} (#{t_format(res.interval)}ms)" }
        },
        {
          check: ->(status) { status == :errored },
          fn: ->(res) { "#{res.url} - ERROR (#{res.message})" }
        }
      ]
    end

    def total_result
      @total_result ||= responses.each_with_object(total) do |res, acc|
        acc[res.status] += 1
        acc[:total] += 1
      end
    end

    def prepare_urls
      responses.map do |res|
        renderers.find { |r| r.fetch(:check).call(res.status) }.fetch(:fn).call(res)
      end.join("\n")
    end

    def prepare_total
      [
        "Total: #{total_result[:total]}",
        "Success: #{total_result[:success]}",
        "Failed: #{total_result[:failed]}",
        "Errored: #{total_result[:errored]}"
      ].join(', ')
    end

    def t_format(time)
      (time * 1000).round
    end
  end
end
