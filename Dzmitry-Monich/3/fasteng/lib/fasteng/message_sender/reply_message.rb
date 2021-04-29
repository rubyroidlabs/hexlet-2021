# frozen_string_literal: true

module Fasteng
  module MessageSender
    module ReplyMessage
      module_function

      MESSAGES = {
        welcome: 'Привет. Я бот, который помогает учить новые английские слова каждый день. ' \
          'Давай сперва определимся сколько слов в день ( от 1 до 6 ) ты хочешь узнавать?',
        welcome_dialog: 'Я не умею учить больше чем 6 словам. Давай еще раз?',
        accept: 'Принято',
        missed: 'Кажется ты был слишком занят, и пропустил слово? Дай мне знать что у тебя все хорошо.',
        done: 'Вижу что ты заметил слово! Продолжаем учиться дальше!',
        end_game: 'Слова закончились'
      }.freeze

      def send(bot_api, chat_id, message_type)
        message = MESSAGES[message_type]
        bot_api.send_message(chat_id: chat_id, text: message)
      end
    end
  end
end
