# frozen_string_literal: true

module Fasteng
  class NotifyHandler
    include Logging

    def self.call
      new.call
    end

    def initialize
      @bot = Telegram::Bot::Client.new(Fasteng.config.token)
      setup
    end

    def call
      return unless User.any?

      User.where(status: %w[scheduled waiting]).find_each do |user|
        logger.info "user: #{user.telegram_id} time: #{actual_time} = #{user.upcoming_time}"

        send_definition!(user) if user.upcoming_time_equal?(actual_time)
        Actions::Reminder.call(bot.api, user, :missed) if user.miss_time?(actual_time)
      end
    end

    private

    attr_reader :bot

    def send_definition!(user)
      definition = DictionaryManager::DictionarySelector.call(user)
      Actions::DefinitionSender.call(bot.api, user, definition)
    end

    def setup
      DatabaseConnector.call
      Dir["#{Fasteng.root_path}/models/**/*.rb"].sort.each { |file| require file }
    end

    # rubocop:disable Lint/RedundantCopDisableDirective
    # rubocop:disable Rails/TimeZone
    def actual_time
      # Time.now.min
      Time.now.hour
    end
    # rubocop:enable Lint/RedundantCopDisableDirective
    # rubocop:enable Rails/TimeZone
  end
end
