# frozen_string_literal: true

module Fasteng
  class MessageResponder
    include Logging

    def initialize(bot, message)
      @bot = bot
      @message = message
    end

    def respond
      logger.info "[#{message.chat.id}] #{message.from.username}: #{message.text}"

      case message.text
      when '/start'
        bot.api.send_message(chat_id: message.chat.id, text: "Hello, #{message.from.first_name}")
      when '/stop'
        bot.api.send_message(chat_id: message.chat.id, text: "Bye, #{message.from.username}: #{message.from.first_name}")
      end
    end

    private

    attr_reader :bot, :message
  end
end
