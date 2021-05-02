# frozen_string_literal: true

module Fasteng
  class Config
    attr_accessor :token, :controller, :url

    def initialize
      @token = ENV['BOT_TOKEN']
      @controller = 'webhook'
    end
  end
end
