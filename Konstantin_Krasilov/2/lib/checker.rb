# frozen_string_literal: true

require 'net/http'

# Links checker
class Checker
  def initialize(link, options)
    @link = link
    @options = options
  end

  def call
    get(@link.uri)
    if (300...400).include?(@response&.code.to_i) && @options.key?(:filter)
      get(URI(@response[:location]), ssl: @response[:location].match?(/https/))
    end

    @response ? parse_response : no_response
  end

  private

  def get(uri, ssl: false)
    @start_time = Time.now
    Net::HTTP.start(uri.host, uri.port, use_ssl: ssl) do |http|
      request = Net::HTTP::Get.new(uri)

      @response = http.request(request)
    end
  rescue StandardError => e
    @link.error = e.message.gsub(/^[^(]+/, 'ERROR ')
  end

  def parse_response
    @link.response_time = ((Time.now - @start_time) * 1_000).round
    @link.code = @response.code.to_i
    @link.valid = false if @options.key?(:filter) && !@response.body.match?(/#{@options[:filter]}/i)
  end

  def no_response
    @link.valid = false if @options.key?(:filter)
  end
end
