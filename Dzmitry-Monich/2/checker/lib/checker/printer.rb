module Checker
  class Printer
    class << self
      def renderers
        {
          success: ->(res) { "#{res.url} - #{res.response.status} (#{format_time(res.interval)}ms)" },
          failed: ->(res) { "#{res.url} - #{res.response.status} (#{format_time(res.interval)}ms)" },
          errored: ->(res) { "#{res.url} - ERROR (#{res.message})" }
        }
      end

      def print(responses)
        output = responses
                 .map { |res| renderers[res.status].call(res) }
                 .join("\n")

        total = format_total(responses)
        [output, total].join("\n\n")
      end

      private

      def calc_total(responses)
        init_total = { total: 0, success: 0, failed: 0, errored: 0 }
        responses.each_with_object(init_total) do |res, acc|
          acc[res.status] += 1
          acc[:total] += 1
        end
      end

      def format_total(responses)
        result = calc_total(responses)
        [
          "Total: #{result[:total]}",
          "Success: #{result[:success]}",
          "Failed: #{result[:failed]}",
          "Errored: #{result[:errored]}"
        ].join(', ')
      end

      def format_time(time)
        (time * 1000).round
      end
    end
  end
end
