# frozen_string_literal: true

require 'dotenv/load'
require 'telegram/bot'
require 'yaml'
require 'active_record'

module Fasteng
  class App
    include Logging

    def initialize
      @client = Telegram::Bot::Client
    end

    def run
      client.run(ENV['BOT_TOKEN']) do |bot|
        logger.info('Bot has been started')

        bot.listen do |msg|
          MessageResponder.new(bot, msg).respond
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
