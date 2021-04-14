# frozen_string_literal: true

module Checker
  class Printer
    class << self
      def print(responses)
        urls = prepare_urls(responses)
        total = prepare_total(responses)
        puts [urls, total].join("\n\n")
      end

      private

      def renderers
        [{ check: ->(status) { %i[success failed].include?(status) },
           fn: lambda do |res|
             "#{res.url} - #{res.response.status} (#{t_format(res.interval)}ms)"
           end },
         { check: ->(status) { status == :errored },
           fn: ->(res) { "#{res.url} - ERROR (#{res.message})" } }]
      end

      def calc_total(responses)
        init_total = { total: 0, success: 0, failed: 0, errored: 0 }
        responses.each_with_object(init_total) do |res, acc|
          acc[res.status] += 1
          acc[:total] += 1
        end
      end

      def prepare_urls(responses)
        responses.map do |res|
          renderers.find { |r| r[:check].call(res.status) }[:fn].call(res)
        end.join("\n")
      end

      def prepare_total(responses)
        result = calc_total(responses)
        [
          "Total: #{result[:total]}",
          "Success: #{result[:success]}",
          "Failed: #{result[:failed]}",
          "Errored: #{result[:errored]}"
        ].join(', ')
      end

      def t_format(time)
        (time * 1000).round
      end
    end
  end
end
