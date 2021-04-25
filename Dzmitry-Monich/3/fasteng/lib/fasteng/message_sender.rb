# frozen_string_literal: true

module Fasteng
  class MessageSender
    def initialize(bot_api, message)
      @bot_api = bot_api
      @message = message
    end

    def welcome_message
      send(
        'Привет. Я бот, который помогает учить новые английские слова каждый день. ' \
        'Давай сперва определимся сколько слов в день ( от 1 до 6 ) ты хочешь узнавать?'
      )
    end

    def answer_message(user)
      case user.status
      when 'registered'
        if answer_valid?(message.text)
          user.update(status: 'scheduled')
          send('Принято')
        else
          send('Я не умею учить больше чем 6 словам. Давай еще раз?')
        end
      end
    end

    private

    attr_reader :bot_api, :message

    def send(msq)
      bot_api.send_message(chat_id: message.chat.id, text: msq)
    end

    def answer_valid?(answer)
      (1..6).map(&:to_s).any?(answer)
    end
  end
end
