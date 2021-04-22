# frozen_string_literal: true

module Printer
  def print_result(request)
    return unless request

    if request.status == :success || request.status == :failed
      puts "#{request.host_name} - #{request.code} (#{request.duration} ms)\n"
    end

    puts "#{request.host_name} - ERROR (#{request.error_message})\n" if request.status == :error
  end

  def print_final_result(requests)
    total_count = requests.keys.inject(0) { |acc, key| acc + requests[key].size }

    puts "\nTotal: #{total_count}, "\
          "Success: #{requests[:success].size}, "\
          "Failed: #{requests[:failed].size}, "\
          "Errored: #{requests[:error].size}\n"
  end
end
