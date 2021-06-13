# frozen_string_literal: true

require_relative '../../models/user'
require_relative '../../models/user_word'

module Telegram
  # A class that expects a message from a user with an emoticon from the user.
  class SendSmiley
    RESPONSE = {
      smiley_success: 'Вижу, что ты заметил слово! Продолжаем учиться дальше!',
      smiley_error: 'Отправь смайл 😉'
    }.freeze

    def initialize(user, message)
      @user = user
      @message = message
    end

    def call
      return RESPONSE[:smiley_error] unless @message.unpack('U*').any? { |e| e.between?(0x1F600, 0x1F6FF) }

      update_user!
      RESPONSE[:smiley_success]
    end

    private

    def update_user!
      @user.user_words.where(created_at: Date.today.all_day).count >= @user.max_words ? @user.sleep! : @user.lesson!
    end
  end
end
