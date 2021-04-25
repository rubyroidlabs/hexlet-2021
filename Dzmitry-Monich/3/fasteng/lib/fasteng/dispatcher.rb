# frozen_string_literal: true

module Fasteng
  class Dispatcher
    include Logging

    def initialize(message, message_sender)
      @message = message
      @message_sender = message_sender
    end

    def dispatch
      if User.exists?(telegram_id: message.from.id)
        @user = User.find_by(telegram_id: message.from.id)
        message_sender.answer_message(user)
      else
        @user = User.create(telegram_id: message.from.id)
        message_sender.welcome_message
      end
    end

    private

    attr_reader :message, :message_sender, :user
  end
end
