# frozen_string_literal: true

module Fasteng
  class Config
    CONTROLLER_TYPES = %w[polling webhook].freeze

    attr_accessor :token, :url
    attr_reader :controller

    def initialize
      @token = ENV['BOT_TOKEN']
      @controller = 'polling'
    end

    def controller=(controller_name)
      validate(controller_name)

      @controller = controller_name
    end

    private

    def validate(controller_name)
      raise ArgumentError, "no such controller: #{controller_name}" unless CONTROLLER_TYPES.include?(controller_name)
    end
  end
end
