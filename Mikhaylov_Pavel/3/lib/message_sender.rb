# frozen_string_literal: true

class MessageSender
  attr_reader :bot, :message

  RESPONSES = {
    greeting: 'Привет. Я бот, который помогает учить новые английские слова каждый день. ' \
    'Давай сперва определимся сколько слов в день (от 1 до 6) ты хочешь узнавать?',
    wrong_number: 'Я не умею учить больше чем 6 словам. Давай еще раз?',
    accept: 'Принято',
    remind: 'Кажется ты был слишком занят, и пропустил слово выше? Дай мне знать что у тебя все хорошо.',
    continue: 'Вижу что ты заметил слово! Продолжаем учиться дальше!'
  }.freeze

  def initialize(bot, message)
    @bot = bot
    @message = message
  end

  def greeting
    bot.api.send_message(
      chat_id: message.chat.id,
      text: RESPONSES[:greeting]
    )
  end

  def accept
    bot.api.send_message(
      chat_id: message.chat.id,
      text: RESPONSES[:accept]
    )
  end

  def wrong_number
    bot.api.send_message(
      chat_id: message.chat.id,
      text: RESPONSES[:wrong_number]
    )
  end
end
