# frozen_string_literal: true

module Fasteng
  class NotifyHandler
    include Logging

    def self.call
      new.call
    end

    def initialize
      @bot = Telegram::Bot::Client.new(ENV['BOT_TOKEN'])
      setup
    end

    def call
      return unless User.any?

      User.where(status: %w[scheduled waiting]).find_each do |user|
        logger.info "user: #{user.telegram_id} time: #{actual_time} = #{user.upcoming_time}"

        send_definition!(user) if user.upcoming_time_equal?(actual_time)
        notify_about_missed_answer(user) if user.miss_time?(actual_time)
      end
    end

    private

    attr_reader :bot

    def send_definition!(user)
      definition = DictionaryManager::DictionarySelector.select(user)
      if definition
        user.receive_definition!(definition)
        MessageSender::NotifyMessage.send(bot.api, user.telegram_id, definition)
      else
        MessageSender::ReplyMessage.send(bot.api, user.telegram_id, :end_game)
      end
    end

    def notify_about_missed_answer(user)
      MessageSender::ReplyMessage.send(bot.api, user.telegram_id, :missed)
    end

    def setup
      DatabaseConnector.sync
      Dir["#{Fasteng.root_path}/models/**/*.rb"].each { |file| require file }
    end

    def actual_time
      # Time.now.min
      Time.now.hour
    end
  end
end
