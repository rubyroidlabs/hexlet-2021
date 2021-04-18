# frozen_string_literal: true

class Printer
  def initialize(data)
    @data = data
    @summary = { total: 0, success: 0, fail: 0, error: 0 }
  end

  def print
    @data.each do |url_data|
      if url_data.key?(:code)
        code = url_data[:code]
        if code >= 200 && code < 400
          @summary[:success] += 1
        elsif code >= 400
          @summary[:fail] += 1
        end
      else
        @summary[:error] += 1
      end
      @summary[:total] += 1
      summary_of_requests_to_s(url_data)
    end
    summary_to_s(@summary)
  end

  def summary_of_requests_to_s(url_data)
    if url_data.key?(:code)
      puts "#{url_data[:url]} - #{url_data[:code]} (#{normalize_time(url_data[:time])}ms)"
    else
      puts "#{url_data[:url]} - ERROR #{url_data[:error]}"
    end
  end

  def summary_to_s(summary)
    total, success, fail, error = summary.values_at(:total, :success, :fail, :error)
    puts "Total: #{total}, Success: #{success}, Failed: #{fail}, Errored: #{error}"
  end

  def normalize_time(time)
    (time * 1000).round
  end
end
