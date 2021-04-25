# frozen_string_literal: true

module Fasteng
  class MessageSender
    MESSAGES = {
      welcome: 'Привет. Я бот, который помогает учить новые английские слова каждый день. ' \
        'Давай сперва определимся сколько слов в день ( от 1 до 6 ) ты хочешь узнавать?',
      welcome_dialog: 'Я не умею учить больше чем 6 словам. Давай еще раз?',
      accept: 'Принято'
    }.freeze

    def initialize(bot_api, chat_id)
      @bot_api = bot_api
      @chat_id = chat_id
    end

    def respond(msg_type)
      message = MESSAGES[msg_type]
      send(message)
    end

    private

    attr_reader :bot_api, :chat_id

    def send(msq)
      bot_api.send_message(chat_id: chat_id, text: msq)
    end
  end
end
