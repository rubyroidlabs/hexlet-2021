# frozen_string_literal: true

module Fasteng
  class BaseController
    include Logging

    def self.run
      new.run
    end

    def initialize
      @bot = Telegram::Bot::Client.new(Fasteng.config.token)
    end

    protected

    attr_reader :bot, :url
  end
end
