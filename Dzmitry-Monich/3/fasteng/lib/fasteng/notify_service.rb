# frozen_string_literal: true

module Fasteng
  class NotifyService
    class << self
      def call
        setup
        User.find_each { |user| send(user.telegram_id, definition) } if User.any?
      end

      private

      def send(chat_id, message)
        bot = Telegram::Bot::Client.new(ENV['BOT_TOKEN'])
        bot.api.send_message(chat_id: chat_id, text: message)
      end

      def definition
        result = Definition.order(Arel.sql('RANDOM()')).first
        "#{result.word}  #{result.description}"
      end

      def setup
        Dir["#{Fasteng.root_path}/models/**/*.rb"].each { |file| require file }
        DatabaseHandler.sync
      end
    end
  end
end
