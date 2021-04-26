# frozen_string_literal: true

module Fasteng
  class Dispatcher
    include Logging

    def initialize(bot_api, message)
      @bot_api = bot_api
      @message = message
      @user = User.find_or_create_by(telegram_id: message.from.id)
    end

    def dispatch
      message_sender = MessageSender.new(bot_api, message.chat.id)

      case user.status
      when 'new'
        user.update!(status: 'registered')
        message_sender.respond(:welcome)
      when 'registered'
        if answer_valid?(message.text)
          user.add_schedule!(message.text)
          message_sender.respond(:accept)
        else
          message_sender.respond(:welcome_dialog)
        end
      end
    end

    private

    attr_reader :bot_api, :message, :user

    def answer_valid?(answer)
      (1..6).map(&:to_s).any?(answer)
    end
  end
end
