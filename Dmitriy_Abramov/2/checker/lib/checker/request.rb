# frozen_string_literal: true

require 'httparty'

module Checker
  class Request
    attr_reader :host_name, :duration, :error_message, :status

    def initialize(host_name)
      @host_name = host_name
      perform
    end

    def error?
      @status == :error
    end

    def success?
      @status == :success
    end

    def failed?
      @status == :failed
    end

    def code
      @response&.code
    end

    def content
      @response&.parsed_response
    end

    private

    def perform
      host = "http://#{@host_name}"
      uri = URI.parse(host)
      start_time = Time.now.utc
      @response = HTTParty.get(uri)
      end_time = Time.now.utc
      @duration = format_time(start_time, end_time)
    rescue StandardError => e
      @error_message = e.message
    ensure
      set_status
    end

    def set_status
      @status = if code.to_s.start_with?('2', '3')
                  :success
                elsif code.to_s.start_with?('4', '5')
                  :failed
                elsif @error_message
                  :error
                end
    end

    def format_time(start_time, end_time)
      ((end_time - start_time) * 1000).round
    end
  end
end
