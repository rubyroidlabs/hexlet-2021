# frozen_string_literal: true

require 'telegramAPI'
require 'dotenv'
require_relative '../../models/user'
require_relative '../../models/word'
require_relative '../../models/user_word'

Dotenv.load

module Telegram
  # A class that teaches the user new words. Searches for a suitable word, sends to the user and waits for a reaction.
  class Lesson
    def initialize(user)
      @user = user
      @api = TelegramAPI.new ENV['TELEGRAM_TOKEN']
    end

    def call
      find_and_added_word_to_user
      send_word
      @user.answer_smiley!
    end

    private

    def find_and_added_word_to_user
      @word = Word.where.not(id: @user.words).order('RANDOM()').first
      @user.words << @word
    end

    def send_word
      @api.sendMessage(@user.telegram_id, @word.to_s)
    end
  end
end
