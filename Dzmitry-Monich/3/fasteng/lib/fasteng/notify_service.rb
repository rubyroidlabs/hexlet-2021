# frozen_string_literal: true

module Fasteng
  class NotifyService
    class << self
      def call
        setup
        return unless User.any?

        User.where(status: %w[scheduled waiting]).find_each do |user|
          if Time.now.hour == user.current_time
            user.add_notification!
            send(user.telegram_id, definition)
          end
        end
      end

      private

      def send(chat_id, message)
        bot = Telegram::Bot::Client.new(ENV['BOT_TOKEN'])
        bot.api.send_message(chat_id: chat_id, text: message, parse_mode: 'Markdown')
      end

      def definition
        result = Definition.order(Arel.sql('RANDOM()')).first
        "**#{result.word}**  #{result.description}"
      end

      def setup
        Dir["#{Fasteng.root_path}/models/**/*.rb"].each { |file| require file }
        DatabaseHandler.sync
      end
    end
  end
end
