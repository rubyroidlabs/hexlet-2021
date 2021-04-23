# frozen_string_literal: true

module Formatter
  def format_domain_result(line)
    return "#{line[:domain]} - ERROR: #{line[:message]}" if line[:error]

    "#{line[:domain]} - #{line[:status]} (#{line[:latency]}ms)"
  end

  def format_summary(summary)
    "\nTotal: #{summary[:total]},"\
    "Success: #{summary[:success]},"\
    " Failed: #{summary[:failed]},"\
    " Errored: #{summary[:errored]}"
  end
end
