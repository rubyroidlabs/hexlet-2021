# frozen_string_literal: true

module Fasteng
  class App
    include Logging

    def initialize
      @client = Telegram::Bot::Client
    end

    def run
      client.run(ENV['BOT_TOKEN']) do |bot|
        # binding.pry
        logger.info 'Bot has been started'

        bot.listen do |message|
          logger.info "[#{message.chat.id}] #{message.from.username}: #{message.text}"
          Thread.new(message) { |msq| Dispatcher.call(bot.api, msq) }
        end
      end
    end

    def init
      DatabaseConnector.sync
      require_models
      DictionaryManager::DictionaryCreator.setup
      self
    end

    private

    attr_reader :client

    def require_models
      Dir["#{Fasteng.root_path}/models/**/*.rb"].sort.each { |file| require file }
    end
  end
end