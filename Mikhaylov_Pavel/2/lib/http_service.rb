# frozen_string_literal: true

require 'faraday'

class HttpService
  OK_STATUSES = [
                200, 201, 202, 203, 204, 205, 206, 207, 208, 226,
                300, 301, 302, 303, 304, 305, 307, 308]

  def initialize(data)
    @data = data
  end

  def responses(stop_word)
    @data.reduce({}) do |result, url|
      begin
        url_data = {}
        start_time = Time.now
        response = Faraday.get "http://#{url}"
        next unless response.body.include?(stop_word)
        url_data[:code] = response.status
        url_data[:time] = Time.now - start_time
      rescue Faraday::ConnectionFailed || Faraday::SSLError => e
        url_data[:error] = e.message
      end
      result[url.to_sym] = url_data
      result
    end
  end
end