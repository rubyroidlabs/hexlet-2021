# frozen_string_literal: true

class Summary
  class Request
    def self.to_s(url_data)
      if url_data.key?(:code)
        puts "#{url_data[:url]} - #{url_data[:code]} (#{normalize_time(url_data[:time])}ms)"
      else
        puts "#{url_data[:url]} - ERROR #{url_data[:error]}"
      end
    end

    def self.normalize_time(time)
      (time * 1000).round
    end
  end

  class Conclusion
    def self.to_s(summary)
      total, success, fail, error = summary.values_at(:total, :success, :fail, :error)
      puts "Total: #{total}, Success: #{success}, Failed: #{fail}, Errored: #{error}"
    end
  end
end
