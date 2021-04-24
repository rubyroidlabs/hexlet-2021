# frozen_string_literal: true

require 'faraday'

class HttpService
  def initialize(data, search_word, parallel)
    @data = data
    @search_word = search_word
    @parallel = parallel.to_i
    @result = []
  end

  def fetch_all
    queue = Queue.new
    @data.each { |url| queue << url }

    Array.new(@parallel) do
      Thread.new do
        until queue.empty?
          next_object = queue.shift
          fetched_url = fetch(next_object)
          unless fetched_url.nil?
            Summary::Request.to_s(fetched_url)
            @result << fetched_url
          end
        end
      end
    end.each(&:join)
    @result
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
