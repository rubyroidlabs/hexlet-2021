# frozen_string_literal: true

module Fasteng
  module Actions
    class Base
      def self.call(*args)
        new(*args).call
      end

      def initialize(bot_api, user, message)
        @bot_api = bot_api
        @user = user
        @message = message
      end

      protected

      attr_reader :bot_api, :user, :message

      def send(message_type)
        MessageSender::ReplyMessage.send(bot_api, user.telegram_id, message_type)
      end

      def notify(definition)
        MessageSender::NotifyMessage.send(bot_api, user.telegram_id, definition)
      end
    end
  end
end
