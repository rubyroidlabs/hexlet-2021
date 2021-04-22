# frozen_string_literal: true

module Checker
  class Printer
    class ResponsePrinter
      class << self
        def print(responses)
          responses.map do |res|
            renderers.find { |r| r.fetch(:check).call(res.status) }.fetch(:fn).call(res)
          end.join("\n")
        end

        private

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

        def t_format(time)
          (time * 1000).round
        end
      end
    end
  end
end
