# frozen_string_literal: true

require 'faraday'

class HttpService
  def initialize(data, search_word)
    @data = data
    @search_word = search_word
  end

  def fetch_all
    result = []
    @data.each do |url|
      if fetch(url) != nil
        result << fetch(url)
      end
    end
    result
  end

  def fetch(url)
    begin
      result = {}
      start_time = Time.now.getlocal
      result[:url] = url
      response = Faraday.get "http://#{url}"
      return unless response.body.include?(@search_word)
      result[:code] = response.status
      result[:time] = Time.now.getlocal - start_time
    rescue StandardError => e
      result[:error] = e.message
    end
    result
  end
end
