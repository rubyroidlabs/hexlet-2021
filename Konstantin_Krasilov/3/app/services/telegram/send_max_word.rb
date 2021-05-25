# frozen_string_literal: true

require_relative '../../models/user'

module Telegram
  # A class that expects from the user information about the maximum word.
  class SendMaxWord
    RESPONSE = {
      max_word_success: 'Принято!',
      max_word_error: 'Сорри, только 6 слов. Давай еще раз?'
    }.freeze

    def initialize(user, message)
      @user = user
      @message = message
    end

    def call
      return RESPONSE[:max_word_error] unless (1..6).cover?(@message.to_i)

      update_user!
      RESPONSE[:max_word_success]
    end

    private

    def update_user!
      @user.update(max_words: @message, aasm_state: 'learning')
    end
  end
end
