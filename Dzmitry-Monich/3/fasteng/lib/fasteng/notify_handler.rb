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
        Actions::DefinitionSender.call(bot.api, user)
        Actions::Reminder.call(bot.api, user, :missed)
      end
    end

    private

    attr_reader :bot

    def setup
      DatabaseConnector.call
      Dir["#{Fasteng.root_path}/models/**/*.rb"].sort.each { |file| require file }
    end
  end
end
