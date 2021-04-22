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

    def listen
      client.run(ENV['BOT_TOKEN']) do |bot|
        logger.info('Bot has been started')

        bot.listen do |msg|
          MessageResponder.new(bot, msg).respond
        end
      end
    end

    def init
      DatabaseConnector.sync
      self
    end

    private

    attr_reader :client, :dictionary
  end
end
