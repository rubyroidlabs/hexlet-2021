# frozen_string_literal: true

module Fasteng
  class App
    include Logging

    def initialize
      @client = Telegram::Bot::Client
    end

    def run
      client.run(ENV['BOT_TOKEN']) do |bot|
        logger.info 'Bot has been started'

        bot.listen do |message|
          logger.info "[#{message.chat.id}] #{message.from.username}: #{message.text}"
          Thread.new { Dispatcher.new(bot.api, message).dispatch }
        end
      end
    end

    def init
      DatabaseHandler.sync
      require_models
      Dictionary.setup
      self
    end

    private

    attr_reader :client

    def require_models
      Dir["#{Fasteng.root_path}/models/**/*.rb"].each { |file| require file }
    end
  end
end
