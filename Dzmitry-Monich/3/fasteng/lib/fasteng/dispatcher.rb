# frozen_string_literal: true

module Fasteng
  class Dispatcher
    def self.call(*args)
      new(*args).call
    end

    def initialize(bot_api, message)
      @bot_api = bot_api
      @message = message
    end

    def call
      action = actions[user.status]
      action.call(bot_api, user, message)
    end

    private

    attr_reader :bot_api, :message

    def user
      @user ||= User.find_or_create_by(telegram_id: message.from.id)
    end

    def actions
      {
        'new' => Actions::Registerer,
        'registered' => Actions::Scheduler,
        'waiting' => Actions::Feedbacker
      }
    end
  end
end
