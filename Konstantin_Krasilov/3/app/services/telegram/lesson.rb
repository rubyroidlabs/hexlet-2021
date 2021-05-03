# frozen_string_literal: true

require 'telegramAPI'
require 'dotenv'
require_relative '../../models/user'
require_relative '../../models/word'
require_relative '../../models/user_word'

Dotenv.load

module Telegram
  # Класс который учит пользователя новым словам. Ищет подходящее слово, отправляет пользователю и ждет реакции.
  class Lesson
    USER_SLEEP = 'Кажется, ты был слишком занят и пропустил слово выше? Дай мне знать, что у тебя все хорошо!'

    def initialize(user)
      @user = user
      @user.send_smiley!
      @api = TelegramAPI.new ENV['TELEGRAM_TOKEN']
    end

    def call
      find_and_added_word_to_user
      send_word
      waiting_answer
    end

    private

    def find_and_added_word_to_user
      @word = Word.where.not(id: @user.words).order('RANDOM()').first
      @user.words << @word
    end

    def send_word
      @api.sendMessage(@user.telegram_id, @word.to_s)
    end

    def waiting_answer
      loop do
        sleep(600)
        @user.reload

        @user.conversation_break? ? break : @api.sendMessage(@user.telegram_id, USER_SLEEP)
      end
    end
  end
end
