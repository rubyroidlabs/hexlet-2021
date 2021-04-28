# frozen_string_literal: true

module Fasteng
  class Dispatcher
    include Logging

    def self.call(*args)
      new(*args).call
    end

    def initialize(bot_api, message)
      @bot_api = bot_api
      @message = message
    end

    def call
      case user.status
      when 'new' then register!
      when 'registered' then add_schedule!
      when 'waiting' then process_answer!
      end
    end

    private

    attr_reader :bot_api, :message, :message_sender

    def user
      @user ||= User.find_or_create_by(telegram_id: message.from.id)
    end

    def first_answer_valid?(answer)
      (1..6).map(&:to_s).any?(answer)
    end

    def notification_accepted?(answer)
      answer == 'done' # replace with emojii
    end

    def register!
      user.update!(status: 'registered')
      send(:welcome)
    end

    def add_schedule!
      if first_answer_valid?(message.text)
        user.add_schedule!(message.text)
        send(:accept)
      else
        send(:welcome_dialog)
      end
    end

    def process_answer!
      return unless notification_accepted?(message.text)

      user.update!(status: 'scheduled')
      send(:done)
    end

    def send(message_type)
      MessageSender::ReplyMessage.send(bot_api, message.chat.id, message_type)
      # MessageSender.sent_by_type(bot_api, message.chat.id, message_type)
    end
  end
end
