# frozen_string_literal: true

module Fasteng
  module Actions
    class Base
      def self.call(*args)
        new(*args).call
      end

      def initialize(bot_api, user, message = nil)
        @bot_api = bot_api
        @user = user
        @message = message if message
      end

      protected

      attr_reader :bot_api, :user, :message

      def send(message_type)
        MessageSender::ReplyMessage.send(bot_api, user.telegram_id, message_type)
      end

      def notify(definition)
        MessageSender::NotifyMessage.send(bot_api, user.telegram_id, definition)
      end

      # rubocop:disable Lint/RedundantCopDisableDirective
      # rubocop:disable Rails/TimeZone
      def actual_time
        # Time.now.min
        Time.now.hour
      end
      # rubocop:enable Rails/TimeZone
      # rubocop:enable Lint/RedundantCopDisableDirective
    end
  end
end
