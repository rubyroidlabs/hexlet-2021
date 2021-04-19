# frozen_string_literal: true

require 'logger'

module Checker
  class Printer
    def print_result(request)
      return unless request

      puts "#{request.host_name} - #{request.code} (#{request.duration} ms)\n" if request.success? || request.failed?

      puts "#{request.host_name} - ERROR (#{request.error_message})\n" if request.error?
    end

    def final_result(requests)
      total_count = requests.keys.inject(0) { |acc, key| acc + requests[key].size }

      puts "\nTotal: #{total_count}, "\
            "Success: #{requests[:success].size}, "\
            "Failed: #{requests[:failed].size}, "\
            "Errored: #{requests[:error].size}\n"
    end
  end
end
