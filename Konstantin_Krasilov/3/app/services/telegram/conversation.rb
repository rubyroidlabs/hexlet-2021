# frozen_string_literal: true

module Telegram
  # The class that communicates using - reacts to responses depending on the status of the conversation.
  class Conversation
    RESPONSE = {
      welcome: 'Привет! Я бот, который помогает учить новые английские слова каждый день. Давай сперва определимся,' \
      'сколько слов в день (от 1 до 6) ты хочешь узнавать?',
      max_word_success: 'Принято!',
      max_word_error: 'Сорри, только 6 слов. Давай еще раз?',
      smiley_success: 'Вижу, что ты заметил слово! Продолжаем учиться дальше!',
      smiley_error: 'Отправь смайл 😉'
    }.freeze

    def initialize(user, message)
      @user = user
      @message = message
    end

    def call
      send(@user.conversation_status)
    end

    private

    def send_max_word
      return RESPONSE[:max_word_error] unless (1..6).cover?(@message.to_i)

      @user.update(max_words: @message, conversation_status: 'conversation_break')
      RESPONSE[:max_word_success]
    end

    def send_smiley
      return RESPONSE[:smiley_error] unless @message.unpack('U*').any? { |e| e.between?(0x1F600, 0x1F6FF) }

      @user.conversation_break!
      RESPONSE[:smiley_success]
    end
  end
end
