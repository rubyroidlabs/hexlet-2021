# frozen_string_literal: true

module Fasteng
  class NotifyService
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
        puts "user: #{user.telegram_id} time: #{actual_time} = #{user.upcoming_time}"
        if user.upcoming_time_equal?(actual_time)
          user.notify!
          MessageSender::NotifyMessage.send(bot.api, user.telegram_id, definition)
        end

        if user.miss_time?(actual_time)
          MessageSender::ReplyMessage.send(bot.api, user.telegram_id, :missed)
        end
      end
    end

    private

    attr_reader :bot

    def definition
      result = Definition.order(Arel.sql('RANDOM()')).first
      "**#{result.word}**  #{result.description}"
    end

    def setup
      Dir["#{Fasteng.root_path}/models/**/*.rb"].each { |file| require file }
      DatabaseConnector.sync
    end

    def actual_time
      # Time.now.min
      Time.now.hour
    end
  end
end
