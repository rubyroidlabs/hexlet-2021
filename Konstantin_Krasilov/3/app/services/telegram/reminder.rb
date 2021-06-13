# frozen_string_literal: true

require 'telegramAPI'
require 'dotenv'
require_relative '../../models/user'

Dotenv.load

module Telegram
  # A class that reminds the user to send an emoticon.
  class Reminder
    MESSAGE = 'Кажется, ты был слишком занят и пропустил слово выше? Дай мне знать, что у тебя все хорошо!'

    def initialize(user)
      @user = user
      @api = TelegramAPI.new ENV['TELEGRAM_TOKEN']
    end

    def call
      @api.sendMessage(@user.telegram_id, MESSAGE)
    end
  end
end
