# frozen_string_literal: true

require_relative 'summary'
class Printer
  def initialize(data)
    @data = data
    @summary = { total: 0, success: 0, fail: 0, error: 0 }
  end

  def print
    @data.each do |url_data|
      if url_data.key?(:code)
        code = url_data[:code]

        @summary[:success] += 1 if code.between?(200, 400)
        @summary[:fail] += 1 if code >= 400
      else
        @summary[:error] += 1
      end
      @summary[:total] += 1
      Summary::Request.to_s(url_data)
    end
    Summary::Conclusion.to_s(@summary)
  end
end
